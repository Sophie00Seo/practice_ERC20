// SPDX-License-Identifier: MIT
// https://eips.ethereum.org/EIPS/eip-712#rationale-for-typehash
// https://eips.ethereum.org/EIPS/eip-2612

pragma solidity ^0.8.0;

contract EIP712 {

    bytes32 private DOMAIN_SEPARATOR;
    
    constructor(string memory name, string memory version) {
        DOMAIN_SEPARATOR = keccak256(abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256(bytes(name)), // string name
            keccak256(bytes(version)), // string version
            block.chainid, // uint256 chainId
            address(this) // address verifyingContract
        ));
    }

    function _domainSeparator() public view returns (bytes32) {
        return DOMAIN_SEPARATOR;
    }
    
    function _toTypedDataHash(bytes32 structHash) public returns (bytes32) {
        return keccak256(abi.encode(uint16(0x1901), DOMAIN_SEPARATOR, structHash));
    }

}