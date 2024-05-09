// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.6.0 <0.8.0;

import "../openzeppelin/contracts/math/SafeMath.sol";

library MonoXLibrary {
  using SafeMath for uint;

  // from https://github.com/Uniswap/uniswap-lib/blob/master/contracts/libraries/TransferHelper.sol
  function safeTransferETH(address to, uint256 value) internal {
      (bool success, ) = to.call{value: value}(new bytes(0));
      require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
  }

  // util func to manipulate vusd balance
  function vusdBalanceAdd (uint256 _credit, uint256 _debt, 
    uint256 delta) internal pure returns (uint256 _newCredit, uint256 _newDebt) {
    if(_debt>0){
      if(delta>_debt){
        _newDebt = 0;
        _newCredit = _credit.add(delta - _debt);
      }else{
        _newCredit = 0;
        _newDebt = _debt - delta;
      }
    }else{
      _newCredit = _credit.add(delta);
      _newDebt = 0;
    }
  }

  // util func to manipulate vusd balance
  function vusdBalanceSub (uint256 _credit, uint256 _debt, 
    uint256 delta) internal pure returns (uint256 _newCredit, uint256 _newDebt) {
    if(_credit>0){
      if(delta>_credit){
        _newCredit = 0;
        _newDebt = delta - _credit;
      }else{
        _newCredit = _credit - delta;
        _newDebt = 0;
      }
    }else{
      _newCredit = 0;
      _newDebt = _debt.add(delta);
    }
  } 
}