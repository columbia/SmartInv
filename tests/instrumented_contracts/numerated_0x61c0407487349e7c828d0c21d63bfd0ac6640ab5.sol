1 pragma solidity ^0.4.13;
2 
3 contract MyToken 
4 
5 {   string public name;
6     string public symbol;
7     uint8 public decimals;
8     uint256 public totalSupply;
9     
10     mapping (address => uint256) public balanceOf;
11     mapping (address => bool) public frozenAccount;
12     event FrozenFunds(address target,bool frozen);
13     event Transfer(address indexed from,address indexed to,uint256 value);
14     
15 
16     function MyToken(uint256 initialSupply,string tokenName,string tokenSymbol,uint8 decimalUnits)
17 
18     {   balanceOf[msg.sender] = initialSupply;
19         totalSupply = initialSupply;
20         name = tokenName;
21         symbol = tokenSymbol;
22         decimals = decimalUnits;
23     }
24 
25     function freezeAccount(address target,bool freeze)
26     
27     {    frozenAccount[target] = freeze;
28          FrozenFunds(target, freeze);
29     }
30 
31     function transfer(address _to, uint256 _value)
32 
33     {   require(!frozenAccount[msg.sender]);
34         require (balanceOf[msg.sender] >= _value);
35         require (balanceOf[_to] + _value >= balanceOf[_to]);
36         balanceOf[msg.sender] -= _value;
37         balanceOf[_to] += _value;
38         Transfer(msg.sender, _to, _value);
39     }
40 }