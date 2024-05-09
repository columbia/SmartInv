// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.10;

/******************************************************************************\
* Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
* Sherlock Protocol: https://sherlock.xyz
/******************************************************************************/

import '../strategy/base/BaseStrategy.sol';

abstract contract BaseStrategyMock {
  function mockUpdateChild(IMaster _parent, INode _newNode) external {
    _parent.updateChild(_newNode);
  }
}

contract TreeStrategyMock is BaseStrategyMock, BaseStrategy {
  event WithdrawAll();
  event Withdraw(uint256 amount);
  event Deposit();

  uint256 public internalWithdrawAllCalled;
  uint256 public internalWithdrawCalled;
  uint256 public internalDepositCalled;
  bool public notWithdraw;

  function setupCompleted() external view override returns (bool) {
    return true;
  }

  constructor(IMaster _initialParent) BaseNode(_initialParent) {}

  function _balanceOf() internal view override returns (uint256) {
    return want.balanceOf(address(this));
  }

  function _withdrawAll() internal override returns (uint256 amount) {
    if (notWithdraw) return 0;
    amount = _balanceOf();
    want.transfer(msg.sender, amount);

    internalWithdrawAllCalled++;

    emit WithdrawAll();
  }

  function _withdraw(uint256 _amount) internal override {
    want.transfer(msg.sender, _amount);

    internalWithdrawCalled++;

    emit Withdraw(_amount);
  }

  function _deposit() internal override {
    internalDepositCalled++;
    emit Deposit();
  }

  function mockSetParent(IMaster _newParent) external {
    parent = _newParent;
  }

  function setNotWithdraw(bool _do) external {
    notWithdraw = _do;
  }
}

contract TreeStrategyMockCustom is BaseStrategyMock, IStrategy {
  address public override core;
  IERC20 public override want;
  IMaster public override parent;
  uint256 public depositCalled;
  uint256 public withdrawCalled;
  uint256 public withdrawByAdminCalled;
  uint256 public withdrawAllCalled;
  uint256 public withdrawAllByAdminCalled;
  uint256 public siblingRemovedCalled;
  bool public override setupCompleted;

  function prepareBalanceCache() external override returns (uint256) {
    return want.balanceOf(address(this));
  }

  function expireBalanceCache() external override {}

  function balanceOf() external view override returns (uint256) {}

  function setSetupCompleted(bool _completed) external {
    setupCompleted = _completed;
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

  function remove() external override {}

  function replace(INode _node) external override {}

  function replaceAsChild(ISplitter _node) external override {}

  function replaceForce(INode _node) external override {}

  function updateParent(IMaster _node) external override {}

  function withdraw(uint256 _amount) external override {
    withdrawCalled++;
    if (want.balanceOf(address(this)) != 0) {
      want.transfer(address(core), _amount);
    }
  }

  function withdrawAll() external override returns (uint256) {
    withdrawAllCalled++;

    uint256 b = want.balanceOf(address(this));
    if (b != 0) {
      want.transfer(address(core), b);
      return b;
    }

    return type(uint256).max;
  }

  function withdrawAllByAdmin() external override returns (uint256) {
    withdrawAllByAdminCalled++;
  }

  function withdrawByAdmin(uint256 _amount) external override {
    withdrawByAdminCalled++;
  }

  function siblingRemoved() external override {
    siblingRemovedCalled++;
  }
}
