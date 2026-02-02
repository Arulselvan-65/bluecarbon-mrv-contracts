// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import {ISubmissionRegistry} from "../interfaces/ISubmissionRegistry.sol";

contract SubmissionRegistry is ISubmissionRegistry {
    uint256 public nextProjectId;
    address public admin;

    enum ProjectStatus {
        CREATED,
        PROOFS_SUBMITTED,
        PENDING,
        APPROVED,
        ACTIVE,
        INACTIVE
    }

    struct Project {
        uint256 projectId;
        address owner;
        string projectName;
        string projectType;
        uint16 areaHa;
        uint256 startDate;
        string lat;
        string long;
        bytes32 proofURI;
        ProjectStatus status;
    }

    mapping(uint256 => Project) public projects;
    mapping(uint256 => address) public projectToFieldOfficer;

    error NotAllowed();
    error ZeroAddress();

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
        bytes32 _uri
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
}
