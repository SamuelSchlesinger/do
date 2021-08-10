// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './Ancestor.sol';

contract SeedDecentralizedOrganization is Ancestor {
  bool retired;
  address newDO;
  mapping(address => mapping(address => bool)) votes;
  address[] members;
  mapping(address => bool) isMember;
  mapping(address => bool) isProposition;
  address[] propositions;

  constructor(address[] memory _members) {
    members = _members;
    for (uint i = 0; i < members.length; i++) {
      isMember[members[i]] = true;
    }
    retired = false;
  }

  modifier active {
    require(!retired);
    _;
  }

  modifier proposition(address prop) {
    require(isProposition[prop], "This proposition was not proposed by a member"); 
    _;
  }

  modifier not_proposition(address not_prop) {
    require(!isProposition[not_prop], "This is already a proposition");
    _;
  }

  modifier successful(address prop) {
    uint voteCount = 0;
    for (uint i = 0; i < members.length; i++) {
      voteCount += votes[prop][members[i]] ? 1 : 0;
    }
    require(voteCount > 2*members.length / 3);
    _;
  }

  modifier member {
    require(isMember[msg.sender]);
    _;
  }

  function vote(address prop) public member proposition(prop) active {
    votes[prop][msg.sender] = true;
  }

  function propose(address new_prop) public member not_proposition(new_prop) {
    isProposition[new_prop] = true;
    propositions.push(new_prop);
  }

  function check(address prop) public successful(prop) proposition(prop) active {
    retired = true;
    newDO = prop;
  }

  function forefather() public pure override returns (address) {
    return address(0);
  }

  function child() public view override returns (address) {
    return newDO;
  }
}
