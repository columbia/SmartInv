1 pragma solidity ^0.4.11;
2 
3 
4 import './linkERC20Basic.sol';
5 import '../math/linkSafeMath.sol';
6 
7 
8 /**
9  * @title Basic token
10  * @dev Basic version of StandardToken, with no allowances. 
11  */
12 contract linkBasicToken is linkERC20Basic {
13   using linkSafeMath for uint256;
14 
15   mapping(address => uint256) balances;
16 
17   /**
18   * @dev transfer token for a specified address
19   * @param _to The address to transfer to.
20   * @param _value The amount to be transferred.
21   */
22   function transfer(address _to, uint256 _value) returns (bool) {
23     balances[msg.sender] = balances[msg.sender].sub(_value);
24     balances[_to] = balances[_to].add(_value);
25     Transfer(msg.sender, _to, _value);
26     return true;
27   }
28 
29   /**
30   * @dev Gets the balance of the specified address.
31   * @param _owner The address to query the the balance of. 
32   * @return An uint256 representing the amount owned by the passed address.
33   */
34   function balanceOf(address _owner) constant returns (uint256 balance) {
35     return balances[_owner];
36   }
37 
38 }
