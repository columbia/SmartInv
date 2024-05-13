1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 import "../openzeppelin/contracts/math/SafeMath.sol";
5 
6 library MonoXLibrary {
7   using SafeMath for uint;
8 
9   // from https://github.com/Uniswap/uniswap-lib/blob/master/contracts/libraries/TransferHelper.sol
10   function safeTransferETH(address to, uint256 value) internal {
11       (bool success, ) = to.call{value: value}(new bytes(0));
12       require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
13   }
14 
15   // util func to manipulate vusd balance
16   function vusdBalanceAdd (uint256 _credit, uint256 _debt, 
17     uint256 delta) internal pure returns (uint256 _newCredit, uint256 _newDebt) {
18     if(_debt>0){
19       if(delta>_debt){
20         _newDebt = 0;
21         _newCredit = _credit.add(delta - _debt);
22       }else{
23         _newCredit = 0;
24         _newDebt = _debt - delta;
25       }
26     }else{
27       _newCredit = _credit.add(delta);
28       _newDebt = 0;
29     }
30   }
31 
32   // util func to manipulate vusd balance
33   function vusdBalanceSub (uint256 _credit, uint256 _debt, 
34     uint256 delta) internal pure returns (uint256 _newCredit, uint256 _newDebt) {
35     if(_credit>0){
36       if(delta>_credit){
37         _newCredit = 0;
38         _newDebt = delta - _credit;
39       }else{
40         _newCredit = _credit - delta;
41         _newDebt = 0;
42       }
43     }else{
44       _newCredit = 0;
45       _newDebt = _debt.add(delta);
46     }
47   } 
48 }