1 pragma solidity >=0.7.0;
2 
3 // SPDX-License-Identifier: BSD-3-Clause
4    
5 contract Owned {
6     modifier onlyOwner() {
7         require(msg.sender==owner);
8         _;
9     }
10     address payable owner;
11     address payable newOwner;
12     
13     function changeOwner(address payable _newOwner) public onlyOwner {
14         require(_newOwner!=address(0));
15         newOwner = _newOwner;
16     }
17     function acceptOwnership() public {
18         if (msg.sender==newOwner) {
19             owner = newOwner;
20         }
21     }
22 }
23 
24 abstract contract ERC20 {
25     uint256 public totalSupply;
26     function balanceOf(address _owner) view public virtual returns (uint256 balance);
27     function transfer(address _to, uint256 _value) public virtual returns (bool success);
28     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
29     function approve(address _spender, uint256 _value) public virtual returns (bool success);
30     function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 
35 contract Token is Owned,  ERC20 {
36     string public symbol;
37     string public name;
38     uint8 public decimals;
39     mapping (address=>uint256) balances;
40     mapping (address=>mapping (address=>uint256)) allowed;
41     
42     function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}
43     
44     function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
45         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
46         balances[msg.sender]-=_amount;
47         balances[_to]+=_amount;
48         emit Transfer(msg.sender,_to,_amount);
49         return true;
50     }
51   
52     function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
53         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
54         balances[_from]-=_amount;
55         allowed[_from][msg.sender]-=_amount;
56         balances[_to]+=_amount;
57         emit Transfer(_from, _to, _amount);
58         return true;
59     }
60   
61     function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
62         allowed[msg.sender][_spender]=_amount;
63         emit Approval(msg.sender, _spender, _amount);
64         return true;
65     }
66     
67     function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
68       return allowed[_owner][_spender];
69     }
70 }
71 
72 contract MetaDM is Token {
73     
74     constructor() {
75         symbol = "META";
76         name = "Meta DM";
77         decimals = 18;
78         totalSupply = 33000000000000000000000;  
79         owner = msg.sender;
80         balances[owner] = totalSupply;
81     }
82     
83     receive () payable external {
84         require(msg.value>0);
85         owner.transfer(msg.value);
86     }
87 }