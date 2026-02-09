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
        address fieldOfficer;
        address verifier;
        ProjectStatus status;
    }

    struct Submission {
        uint256 submissionId;
        uint256 projectId;
        uint256 timeStamp;
        bytes proofURI;
        SubmissionStatus status;
    }

    mapping(uint256 => Project) public projects;
    mapping(uint256 => Submission) public projectToSubmission;

    error NotAllowed();
    error ZeroAddress();
    error InvalidURI();

    modifier onlyAdmin() {
        _onlyAdmin();
        _;
    }

    modifier onlyFieldOfficer(uint256 projectId) {
        _onlyFieldOfficer(projectId);
        _;
    }

    function _onlyAdmin() internal view {
        require(msg.sender == admin, NotAllowed());
    }

    function _onlyFieldOfficer(uint256 projectId) internal view {
        require(projects[projectId].fieldOfficer == msg.sender, NotAllowed());
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
            fieldOfficer: address(0),
            verifier: address(0),
            status: ProjectStatus.CREATED
        });
        projects[projectId] = project;
        return projectId;
    }

    function setFieldOfficer(uint256 projectId, address _fieldOfficer) external onlyAdmin {
        require(_fieldOfficer != address(0), ZeroAddress());
        require(projects[projectId].status == ProjectStatus.CREATED);
        projects[projectId].fieldOfficer = _fieldOfficer;
    }

    function submitProofs(uint256 _projectId, bytes calldata _proofUri, SubmissionStatus _status)
        external
        onlyFieldOfficer(_projectId)
    {
        Project storage project = projects[_projectId];
        require(project.status == ProjectStatus.CREATED);
        if (_status == SubmissionStatus.REJECTED) {
            project.status = ProjectStatus.REJECTED;
        } else {
            require(_proofUri.length > 0, InvalidURI());
            uint256 submissionId = nextSubmissionId++;
            Submission memory submission = Submission({
                submissionId: submissionId,
                projectId: _projectId,
                timeStamp: block.timestamp,
                proofURI: _proofUri,
                status: _status
            });
            projectToSubmission[_projectId] = submission;
            project.status = ProjectStatus.PROOFS_SUBMITTED;
        }
    }
}
