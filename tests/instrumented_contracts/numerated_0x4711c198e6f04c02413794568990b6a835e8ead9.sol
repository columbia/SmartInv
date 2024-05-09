1 pragma solidity ^0.4.18;
2 
3 contract MyOwned {
4     address public owner;
5     function MyOwned() public { owner = msg.sender; }
6     modifier onlyOwner { require(msg.sender == owner ); _; }
7     function transferOwnership(address newOwner) onlyOwner public { owner = newOwner; }
8 }
9 
10 interface tokenRecipient { 
11     function receiveApproval(
12         address _from, 
13         uint256 _value, 
14         address _token, 
15         bytes _extraData) public; 
16 }
17 
18 contract MyToken is MyOwned {   
19     string public name;
20     string public symbol;
21     uint8 public decimals;
22     uint256 public totalSupply;
23     
24     mapping (address => uint256) public balanceOf;
25     mapping (address => bool) public frozenAccount;
26     event FrozenFunds(address target,bool frozen);
27     event Transfer(address indexed from,address indexed to,uint256 value);
28     
29     function MyToken(
30         string tokenName,
31         string tokenSymbol,
32         uint8 decimalUnits,
33         uint256 initialSupply)public{
34 
35         name = tokenName;
36         symbol = tokenSymbol;
37         decimals = decimalUnits;
38         totalSupply = initialSupply;
39         balanceOf[msg.sender] = initialSupply;
40     }
41 
42     function transfer(address _to, uint256 _value)public{
43         require(!frozenAccount[msg.sender]);
44         require (balanceOf[msg.sender] >= _value);
45         require (balanceOf[_to] + _value >= balanceOf[_to]);
46         balanceOf[msg.sender] -= _value;
47         balanceOf[_to] += _value;
48         Transfer(msg.sender, _to, _value);
49     }
50     
51     function freezeAccount(address target,bool freeze)public onlyOwner {
52         frozenAccount[target] = freeze;
53         FrozenFunds(target, freeze);
54     }
55     
56     function mintToken(address target, uint256 mintedAmount)public onlyOwner {
57         balanceOf[target] += mintedAmount;
58         Transfer(0, this, mintedAmount);
59         Transfer(this, target, mintedAmount);
60     }
61 }