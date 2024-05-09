1 pragma solidity ^0.5.1;
2 
3 contract Owned {
4     modifier onlyOwner() {
5         require(msg.sender == owner);
6         _;
7     }
8     address public owner;
9     address public newOwner;
10     function changeOwner(address _newOwner) public onlyOwner {
11         newOwner = _newOwner;
12     }
13     function acceptOwnership() public {
14         if (msg.sender == newOwner) {
15             owner = newOwner;
16         }
17     }
18 }
19 
20 contract ERC20 {
21     uint256 public totalSupply;
22     function balanceOf(address _owner) view public returns (uint256 balance);
23     function transfer(address _to, uint256 _value) public returns (bool success);
24     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
25     function approve(address _spender, uint256 _value) public returns (bool success);
26     function allowance(address _owner, address _spender) view public returns (uint256 remaining);
27     event Transfer(address indexed _from, address indexed _to, uint256 _value);
28     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
29 }
30 
31 contract Token is Owned,  ERC20 {
32     string public symbol;
33     string public name;
34     uint8 public decimals;
35     mapping (address=>uint256) balances;
36     mapping (address=>mapping (address=>uint256)) allowed;
37     
38     function balanceOf(address _owner) view public returns (uint256 balance) {return balances[_owner];}
39     
40     function transfer(address _to, uint256 _amount) public returns (bool success) {
41         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
42         balances[msg.sender]-=_amount;
43         balances[_to]+=_amount;
44         emit Transfer(msg.sender,_to,_amount);
45         return true;
46     }
47   
48     function transferFrom(address _from,address _to,uint256 _amount) public returns (bool success) {
49         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
50         balances[_from]-=_amount;
51         allowed[_from][msg.sender]-=_amount;
52         balances[_to]+=_amount;
53         emit Transfer(_from, _to, _amount);
54         return true;
55     }
56   
57     function approve(address _spender, uint256 _amount) public returns (bool success) {
58         allowed[msg.sender][_spender]=_amount;
59         emit Approval(msg.sender, _spender, _amount);
60         return true;
61     }
62     
63     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
64       return allowed[_owner][_spender];
65     }
66     
67     function mint(uint256 _amount) public onlyOwner returns (bool success) {
68         require (_amount>0);
69         balances[owner]+=_amount;
70         return true;
71     }
72 }
73 
74 contract SEC is Token{
75     
76     constructor() public{
77         symbol = "SEC";
78         name = "BitSender";
79         decimals = 0;
80         totalSupply = 1000000;
81         owner = msg.sender;
82         balances[owner] = totalSupply;
83     }
84     
85     function () payable external {
86         revert();
87     }
88 }