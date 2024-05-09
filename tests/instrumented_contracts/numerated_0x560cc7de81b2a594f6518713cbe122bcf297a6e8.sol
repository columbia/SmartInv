1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 contract Owned {
6     modifier onlyOwner() {
7         require(msg.sender==owner);
8         _;
9     }
10     address payable owner;
11     address payable newOwner;
12     function changeOwner(address payable _newOwner) public onlyOwner {
13         require(_newOwner!=address(0));
14         newOwner = _newOwner;
15     }
16     function acceptOwnership() public {
17         if (msg.sender==newOwner) {
18             owner = newOwner;
19         }
20     }
21 }
22 
23 abstract contract ERC20 {
24     uint256 public totalSupply;
25     function balanceOf(address _owner) view public virtual returns (uint256 balance);
26     function transfer(address _to, uint256 _value) public virtual returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
28     function approve(address _spender, uint256 _value) public virtual returns (bool success);
29     function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32 }
33 
34 contract Token is Owned,  ERC20 {
35     string public symbol;
36     string public name;
37     uint8 public decimals;
38     mapping (address=>uint256) balances;
39     mapping (address=>mapping (address=>uint256)) allowed;
40     
41     function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}
42     
43     function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
44         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
45         balances[msg.sender]-=_amount;
46         balances[_to]+=_amount;
47         emit Transfer(msg.sender,_to,_amount);
48         return true;
49     }
50   
51     function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
52         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
53         balances[_from]-=_amount;
54         allowed[_from][msg.sender]-=_amount;
55         balances[_to]+=_amount;
56         emit Transfer(_from, _to, _amount);
57         return true;
58     }
59   
60     function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
61         allowed[msg.sender][_spender]=_amount;
62         emit Approval(msg.sender, _spender, _amount);
63         return true;
64     }
65     
66     function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
67       return allowed[_owner][_spender];
68     }
69 }
70 
71 contract IMPULSEVEN is Token{
72     
73     constructor() {
74         symbol = "i7";
75         name = "IMPULSEVEN";
76         decimals = 18;
77         totalSupply = 10000000000000000000000000;  
78         owner =payable (msg.sender);
79         balances[owner] = totalSupply;
80     }
81     
82     receive () payable external {
83         require(msg.value>0);
84         owner.transfer(msg.value);
85     }
86 }