// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "node_modules/@ensdomains/ens-contracts";

contract SubdomainRegistrar {
    ENS public ens;
    Resolver public resolver;
    address public owner;
    bytes32 public accessorNode;

    constructor(ENS _ens, Resolver _resolver, bytes32 _accessorNode) {
        ens = _ens;
        resolver = _resolver;
        accessorNode = _accessorNode;
        owner = msg.sender;
    }

    function registerSubdomain(bytes32 _label, address _owner) public {
        require(msg.sender == owner, "Only the owner can register subdomains.");

        // Compute the subdomain node
        bytes32 subdomainNode = keccak256(abi.encodePacked(accessorNode, _label));

        // Set the subdomain owner
        ens.setSubnodeOwner(accessorNode, _label, _owner);

        // Set the resolver for the subdomain
        ens.setResolver(subdomainNode, address(resolver));

        // Set the address record for the subdomain
        resolver.setAddr(subdomainNode, _owner);
    }
}
