// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

/******************************************************************************\
* Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
* Sherlock Protocol: https://sherlock.xyz
/******************************************************************************/

import '../strategy/base/BaseSplitter.sol';

contract TreeSplitterMock is BaseSplitter {
  constructor(
    IMaster _initialParent,
    INode _initialChildOne,
    INode _initialChildTwo
  ) BaseSplitter(_initialParent, _initialChildOne, _initialChildTwo) {}

  function _withdraw(uint256 _amount) internal virtual override {
    if (_amount % (2 * 10**6) == 0) {
      // if USDC amount is even
      childOne.withdraw(_amount);
    } else if (_amount % (1 * 10**6) == 0) {
      // if USDC amount is uneven
      childTwo.withdraw(_amount);
    } else {
      // if USDC has decimals
      revert('WITHDRAW');
    }
  }

  function _deposit() internal virtual override {
    uint256 balance = want.balanceOf(address(this));

    if (balance % (2 * 10**6) == 0) {
      // if USDC amount is even
      want.transfer(address(childOne), balance);
      childOne.deposit();
    } else if (balance % (1 * 10**6) == 0) {
      // if USDC amount is uneven
      want.transfer(address(childTwo), balance);
      childTwo.deposit();
    } else {
      // if USDC has decimals
      revert('DEPOSIT');
    }
  }
}

contract TreeSplitterMockCustom is ISplitter {
  address public override core;
  IERC20 public override want;
  IMaster public override parent;
  uint256 public depositCalled;
  uint256 public withdrawCalled;
  uint256 public withdrawByAdminCalled;
  uint256 public withdrawAllCalled;
  uint256 public withdrawAllByAdminCalled;
  uint256 public childRemovedCalled;
  INode public updateChildCalled;
  INode public override childOne;
  INode public override childTwo;
  bool public override setupCompleted;

  function prepareBalanceCache() external override returns (uint256) {
  }

  function expireBalanceCache() external override {
  }

  function balanceOf() external view override returns (uint256) {}

  function setSetupCompleted(bool _completed) external {
    setupCompleted = _completed;
  }

  function setChildOne(INode _child) external {
    childOne = _child;
  }

  function setChildTwo(INode _child) external {
    childTwo = _child;
  }

  function setCore(address _core) external {
    core = _core;
  }

  function setWant(IERC20 _want) external {
    want = _want;
  }

  function setParent(IMaster _parent) external {
    parent = _parent;
  }

  function deposit() external override {
    depositCalled++;
  }

  function replace(INode _node) external override {}

  function replaceAsChild(ISplitter _node) external override {}

  function replaceForce(INode _node) external override {}

  function updateParent(IMaster _node) external override {}

  function withdraw(uint256 _amount) external override {
    withdrawCalled++;
  }

  function withdrawAll() external override returns (uint256) {
    withdrawAllCalled++;
    return type(uint256).max;
  }

  function withdrawAllByAdmin() external override returns (uint256) {
    withdrawAllByAdminCalled++;
  }

  function withdrawByAdmin(uint256 _amount) external override {
    withdrawByAdminCalled++;
  }

  /// @notice Call by child if it's needs to be updated
  function updateChild(INode _node) external override {
    updateChildCalled = _node;
  }

  /// @notice Call by child if removed
  function childRemoved() external override {
    childRemovedCalled++;
  }

  function isMaster() external view override returns (bool) {}

  function setInitialChildOne(INode _child) external override {}

  function setInitialChildTwo(INode _child) external override {}

  function siblingRemoved() external override {}
}

contract TreeSplitterMockTest {
  address public core;
  IERC20 public want;

  function setCore(address _core) external {
    core = _core;
  }

  function setWant(IERC20 _want) external {
    want = _want;
  }

  function deposit(INode _strategy) external {
    _strategy.deposit();
  }

  function withdraw(INode _strategy, uint256 _amount) external {
    _strategy.withdraw(_amount);
  }

  function withdrawAll(INode _strategy) external {
    _strategy.withdrawAll();
  }
}
