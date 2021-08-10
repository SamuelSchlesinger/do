// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract Ancestor {
  function forefather() virtual external returns (address);
  function child() virtual external returns (address);

  modifier not_zero(address y) {
    require(y != address(0), "Address was equal to zero");
    _;
  }

  function ancestor(address y) external not_zero(y) {
    address x = this.forefather();
    while (x != y) {
      x = Ancestor(x).forefather();
      require(x != address(0));
    }
  }

  function descendant(address y) external not_zero(y) {
    address x = this.child();
    while (x != y) {
      x = Ancestor(x).child();
      require(x != address(0));
    }
  }
}
