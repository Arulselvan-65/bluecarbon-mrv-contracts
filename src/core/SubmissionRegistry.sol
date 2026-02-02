// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {ISubmissionRegistry} from "../interfaces/ISubmissionRegistry.sol";
import {ProjectStatus} from "../enums/ProjectStatus.sol";
import {SubmissionStatus} from "../enums/SubmissionStatus.sol";

contract SubmissionRegistry is ISubmissionRegistry {
    uint256 public nextProjectId;
    uint256 public nextSubmissionId = 1;
    address public admin;

    struct Project {
        uint256 projectId;
        address owner;
        string projectName;
        string projectType;
        uint16 areaHa;
        uint256 startDate;
        string lat;
        string long;
        bytes proofURI;
        ProjectStatus status;
    }

    struct Submission {
        uint256 submissionId;
        uint256 projectId;
        address fieldOfficer;
        uint256 timeStamp;
        bytes proofURI;
        SubmissionStatus status;
    }

    mapping(uint256 => Project) public projects;
    mapping(uint256 => Submission) public projectToSubmission;
    mapping(uint256 => address) public projectToFieldOfficer;

    error NotAllowed();
    error ZeroAddress();
    error InvalidURI();

    modifier onlyAdmin() {
        _onlyAdmin();
        _;
    }

    function _onlyAdmin() internal view {
        require(msg.sender == admin, NotAllowed());
    }

    function create(
        string calldata _name,
        string calldata _projectType,
        uint16 _areaHa,
        uint256 _startDate,
        string calldata _lat,
        string calldata _long,
        bytes calldata _uri
    ) external returns (uint256) {
        uint256 projectId = nextProjectId++;
        Project memory project = Project({
            projectId: projectId,
            owner: msg.sender,
            projectName: _name,
            projectType: _projectType,
            areaHa: _areaHa,
            startDate: _startDate,
            lat: _lat,
            long: _long,
            proofURI: _uri,
            status: ProjectStatus.CREATED
        });
        projects[projectId] = project;
        return projectId;
    }

    function setFieldOfficer(uint256 projectId, address _fieldOfficer) external onlyAdmin {
        require(_fieldOfficer != address(0), ZeroAddress());
        projectToFieldOfficer[projectId] = _fieldOfficer;
    }

    function submitProofs(uint256 _projectId, bytes calldata _proofUri, SubmissionStatus _status) external {
        require(projects[_projectId].status == ProjectStatus.CREATED);
        require(projectToFieldOfficer[_projectId] == msg.sender, NotAllowed());
        require(_proofUri.length > 0, InvalidURI());
        uint256 submissionId = nextSubmissionId++;
        Submission memory submission = Submission({
            submissionId: submissionId,
            projectId: _projectId,
            fieldOfficer: msg.sender,
            timeStamp: block.timestamp,
            proofURI: _proofUri,
            status: _status
        });
        projectToSubmission[_projectId] = submission;
    }
}
