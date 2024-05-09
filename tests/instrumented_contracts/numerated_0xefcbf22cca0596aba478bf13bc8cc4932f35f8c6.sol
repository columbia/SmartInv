1 pragma solidity ^0.4.25;
2 
3 contract dbCoin {
4     string public name = "dbCoin";
5     string public symbol = "dbc";
6     uint8 public decimals = 0;
7     uint256 public totalSupply = 1000000;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     
14     constructor() public {
15         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
16     }
17 
18     /**
19      * Internal transfer, only can be called by this contract
20      */
21     function _transfer(address _from, address _to, uint _value) internal {
22         require(balanceOf[_from] >= _value);
23         require(balanceOf[_to] + _value >= balanceOf[_to]);
24         uint previousBalances = balanceOf[_from] + balanceOf[_to];
25         balanceOf[_from] -= _value;
26         balanceOf[_to] += _value;
27         emit Transfer(_from, _to, _value);
28         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
29     }
30 
31     /**
32      * Transfer tokens
33      *
34      * Send `_value` tokens to `_to` from your account
35      *
36      * @param _to The address of the recipient
37      * @param _value the amount to send
38      */
39     function transfer(address _to, uint256 _value) public returns (bool success) {
40         _transfer(msg.sender, _to, _value);
41         return true;
42     }
43 }