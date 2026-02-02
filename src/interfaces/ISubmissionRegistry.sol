// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;
import {SubmissionStatus} from "../enums/SubmissionStatus.sol";

interface ISubmissionRegistry {
    function create(
        string calldata name,
        string calldata projType,
        uint16 _areaHa,
        uint256 startDate,
        string calldata lat,
        string calldata long,
        bytes calldata uri
    ) external returns (uint256);

    function setFieldOfficer(uint256 projectId, address _fieldOfficer) external;

    function submitProofs(uint256 projectId, bytes calldata proofURI, SubmissionStatus _status) external;
}
