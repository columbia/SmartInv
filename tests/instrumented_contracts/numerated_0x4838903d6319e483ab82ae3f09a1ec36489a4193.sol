1 pragma solidity 0.7.0;
2 
3 // SPDX-License-Identifier: MIT
4 
5 contract Owned {
6     modifier onlyOwner() {
7         require(msg.sender == owner);
8         _;
9     }
10     address owner;
11     address newOwner;
12     function changeOwner(address payable _newOwner) public onlyOwner {
13         newOwner = _newOwner;
14     }
15     function acceptOwnership() public {
16         if (msg.sender == newOwner) {
17             owner = newOwner;
18         }
19     }
20 }
21 
22 contract ERC20 {
23     string public symbol;
24     string public name;
25     uint8 public decimals;
26     uint256 public totalSupply;
27     mapping (address=>uint256) balances;
28     mapping (address=>mapping (address=>uint256)) allowed;
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31     
32     function balanceOf(address _owner) view public returns (uint256 balance) {return balances[_owner];}
33     
34     function transfer(address _to, uint256 _amount) public returns (bool success) {
35         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
36         balances[msg.sender]-=_amount;
37         balances[_to]+=_amount;
38         emit Transfer(msg.sender,_to,_amount);
39         return true;
40     }
41   
42     function transferFrom(address _from,address _to,uint256 _amount) public returns (bool success) {
43         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
44         balances[_from]-=_amount;
45         allowed[_from][msg.sender]-=_amount;
46         balances[_to]+=_amount;
47         emit Transfer(_from, _to, _amount);
48         return true;
49     }
50   
51     function approve(address _spender, uint256 _amount) public returns (bool success) {
52         allowed[msg.sender][_spender]=_amount;
53         emit Approval(msg.sender, _spender, _amount);
54         return true;
55     }
56     
57     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
58       return allowed[_owner][_spender];
59     }
60 }
61 
62 contract FamousCoin  is Owned,ERC20{
63     uint256 public maxSupply;
64 
65     constructor(address _owner) {
66         symbol = "FAMOUS";
67         name = "Famous Coin";
68         decimals = 18;                             // 18 Decimals
69         totalSupply = 23000000e18;                 // 23,000,000 FAMOUS and 18 Decimals
70         maxSupply   = 23000000e18;                 // 23,000,000 FAMOUS and 18 Decimals
71         owner = _owner;
72         balances[owner] = totalSupply;
73     }
74     
75     receive() external payable {
76         revert();
77     }
78 }