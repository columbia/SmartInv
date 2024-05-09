1 pragma solidity ^0.4.20;
2 
3 contract MyOwned {
4 
5     address public owner;
6     function MyOwned() public { owner = msg.sender; }
7     modifier onlyOwner { require(msg.sender == owner ); _; }
8     function transferOwnership (address newOwner) onlyOwner public { owner = newOwner; }
9 }
10 
11 contract MyToken is MyOwned {   
12 
13     string public name;
14     string public symbol;
15     uint8 public decimals;
16     uint256 public totalSupply;
17     
18     mapping (address => uint256) public balanceOf;
19     mapping (address => bool) public frozenAccount;
20     event Burn (address indexed from,uint256 value);    
21     event FrozenFunds (address target,bool frozen);
22     event Transfer (address indexed from,address indexed to,uint256 value);
23     
24     function MyToken(
25 
26         string tokenName,
27         string tokenSymbol,
28         uint8 decimalUnits,
29         uint256 initialSupply) public {
30 
31         name = tokenName;
32         symbol = tokenSymbol;
33         decimals = decimalUnits;
34         totalSupply = initialSupply;
35         balanceOf[msg.sender] = initialSupply;
36     }
37 
38     function transfer (address _to, uint256 _value) public {
39 
40         require(!frozenAccount[msg.sender]);
41         require (balanceOf[msg.sender] >= _value);
42         require (balanceOf[_to] + _value >= balanceOf[_to]);
43         balanceOf[msg.sender] -= _value;
44         balanceOf[_to] += _value;
45         Transfer(msg.sender, _to, _value);
46     }
47     
48     function freezeAccount (address target,bool freeze) public onlyOwner {
49 
50         frozenAccount[target] = freeze;
51         FrozenFunds(target, freeze);
52     }
53 
54     function mintToken (address target, uint256 mintedAmount) public onlyOwner {
55 
56         balanceOf[target] += mintedAmount;
57         Transfer(0, this, mintedAmount);
58         Transfer(this, target, mintedAmount);
59     }
60     
61     function burnFrom (address _from,uint256 _value) public onlyOwner {
62 
63         require(balanceOf[_from] >= _value); 
64         balanceOf[_from] -= _value; 
65         Burn(_from, _value);
66     }        
67 }