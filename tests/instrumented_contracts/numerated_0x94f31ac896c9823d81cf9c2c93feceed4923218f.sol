1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-08
3 */
4 
5 pragma solidity ^0.6.7;
6 
7    // Telegram: https://t.me/yftether
8    // Website : https://yftether.io
9    
10 contract Owned {
11     modifier onlyOwner() {
12         require(msg.sender==owner);
13         _;
14     }
15     address payable owner;
16     address payable newOwner;
17     function changeOwner(address payable _newOwner) public onlyOwner {
18         require(_newOwner!=address(0));
19         newOwner = _newOwner;
20     }
21     function acceptOwnership() public {
22         if (msg.sender==newOwner) {
23             owner = newOwner;
24         }
25     }
26 }
27 
28 abstract contract ERC20 {
29     uint256 public totalSupply;
30     function balanceOf(address _owner) view public virtual returns (uint256 balance);
31     function transfer(address _to, uint256 _value) public virtual returns (bool success);
32     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
33     function approve(address _spender, uint256 _value) public virtual returns (bool success);
34     function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 contract Token is Owned,  ERC20 {
40     string public symbol;
41     string public name;
42     uint8 public decimals;
43     mapping (address=>uint256) balances;
44     mapping (address=>mapping (address=>uint256)) allowed;
45     
46     function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}
47     
48     function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
49         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
50         balances[msg.sender]-=_amount;
51         balances[_to]+=_amount;
52         emit Transfer(msg.sender,_to,_amount);
53         return true;
54     }
55   
56     function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
57         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
58         balances[_from]-=_amount;
59         allowed[_from][msg.sender]-=_amount;
60         balances[_to]+=_amount;
61         emit Transfer(_from, _to, _amount);
62         return true;
63     }
64   
65     function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
66         allowed[msg.sender][_spender]=_amount;
67         emit Approval(msg.sender, _spender, _amount);
68         return true;
69     }
70     
71     function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
72       return allowed[_owner][_spender];
73     }
74 }
75 
76 contract YFTether is Token{
77     
78     constructor() public{
79         symbol = "YFTE";
80         name = "YfTether.io";
81         decimals = 18;
82         totalSupply = 21000000000000000000000;  
83         owner = msg.sender;
84         balances[owner] = totalSupply;
85     }
86     
87     receive () payable external {
88         require(msg.value>0);
89         owner.transfer(msg.value);
90     }
91 }