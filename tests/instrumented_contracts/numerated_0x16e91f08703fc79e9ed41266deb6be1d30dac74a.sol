1 pragma solidity ^0.4.15;
2 
3 contract MyOwned {
4     address public owner;
5     function MyOwned() public { owner = msg.sender; }
6     modifier onlyOwner { require(msg.sender == owner ); _; }
7     function transferOwnership(address newOwner) onlyOwner public { owner = newOwner; }
8 }
9 
10 interface recipient { 
11     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
12 }
13 
14 contract MyToken is MyOwned {   
15     string public name;
16     string public symbol;
17     uint8 public decimals;
18     uint256 public totalSupply;
19     
20     mapping (address => uint256) public balanceOf;
21     mapping (address => bool) public frozenAccount;
22     event FrozenFunds(address target,bool frozen);
23     event Transfer(address indexed from,address indexed to,uint256 value);
24     
25 
26     function MyToken(uint256 initialSupply,string tokenName,string tokenSymbol,uint8 decimalUnits){
27         balanceOf[msg.sender] = initialSupply;
28         totalSupply = initialSupply;
29         name = tokenName;
30         symbol = tokenSymbol;
31         decimals = decimalUnits;
32     }
33 
34     function freezeAccount(address target,bool freeze) onlyOwner {
35         frozenAccount[target] = freeze;
36         FrozenFunds(target, freeze);
37     }
38 
39     function transfer(address _to, uint256 _value){
40         require(!frozenAccount[msg.sender]);
41         require (balanceOf[msg.sender] >= _value);
42         require (balanceOf[_to] + _value >= balanceOf[_to]);
43         balanceOf[msg.sender] -= _value;
44         balanceOf[_to] += _value;
45         Transfer(msg.sender, _to, _value);
46     }
47         function mintToken(address target, uint256 mintedAmount) onlyOwner {
48         balanceOf[target] += mintedAmount;
49         Transfer(0, this, mintedAmount);
50         Transfer(this, target, mintedAmount);
51     }
52 }