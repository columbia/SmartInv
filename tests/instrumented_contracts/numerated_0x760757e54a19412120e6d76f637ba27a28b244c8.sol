1 pragma solidity ^0.4.19;
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
17     uint256 public firstPublish;
18     
19     mapping (address => uint256) public balanceOf;
20     mapping (address => bool) public frozenAccount;
21     event Burn (address indexed from,uint256 value);
22     event FrozenFunds (address target,bool frozen);
23     event Transfer (address indexed from,address indexed to,uint256 value);
24     
25     function MyToken(
26 
27         string _Name,
28         string _Symbol,
29         uint8 _decimals,
30         uint256 _totalSupply,
31         uint256 _firstPublish) public {
32 
33         name = _Name;
34         symbol = _Symbol;
35         decimals = _decimals;
36         totalSupply = _totalSupply;
37         firstPublish = _firstPublish;
38         balanceOf[msg.sender] = _firstPublish;
39     }
40 
41     function transfer (address _to, uint256 _value) public {
42 
43         require(!frozenAccount[msg.sender]);
44         require (balanceOf[msg.sender] >= _value);
45         require (balanceOf[_to] + _value >= balanceOf[_to]);
46         balanceOf[msg.sender] -= _value;
47         balanceOf[_to] += _value;
48         Transfer(msg.sender, _to, _value);
49     }
50     
51     function freezeAccount (address target,bool freeze) public onlyOwner {
52 
53         frozenAccount[target] = freeze;
54         FrozenFunds(target, freeze);
55     }
56     
57     function burnFrom (address _from,uint256 _value) public onlyOwner {
58 
59         require(balanceOf[_from] >= _value); 
60         balanceOf[_from] -= _value; 
61         Burn(_from, _value);
62     }    
63     function mintTo (address target, uint256 mintedAmount) public onlyOwner {
64 
65         balanceOf[target] += mintedAmount;
66         Transfer(0, this, mintedAmount);
67         Transfer(this, target, mintedAmount);
68     }
69 }