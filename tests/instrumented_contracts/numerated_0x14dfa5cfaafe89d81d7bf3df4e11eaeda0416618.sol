1 pragma solidity ^0.6.7;
2 
3    // Telegram: https://t.me/copsfinancechat
4    // Website : https://copsfinance.com
5    //Twitter : https://twitter.com/CopsFinace
6 
7 contract Owned {
8     modifier onlyOwner() {
9         require(msg.sender==owner);
10         _;
11     }
12     address payable owner;
13     address payable newOwner;
14     function changeOwner(address payable _newOwner) public onlyOwner {
15         require(_newOwner!=address(0));
16         newOwner = _newOwner;
17     }
18     function acceptOwnership() public {
19         if (msg.sender==newOwner) {
20             owner = newOwner;
21         }
22     }
23 }
24 
25 abstract contract ERC20 {
26     uint256 public totalSupply;
27     function balanceOf(address _owner) view public virtual returns (uint256 balance);
28     function transfer(address _to, uint256 _value) public virtual returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
30     function approve(address _spender, uint256 _value) public virtual returns (bool success);
31     function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
32     event Transfer(address indexed _from, address indexed _to, uint256 _value);
33     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 }
35 
36 contract Token is Owned,  ERC20 {
37     string public symbol;
38     string public name;
39     uint8 public decimals;
40     mapping (address=>uint256) balances;
41     mapping (address=>mapping (address=>uint256)) allowed;
42     
43     function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}
44     
45     function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
46         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
47         balances[msg.sender]-=_amount;
48         balances[_to]+=_amount;
49         emit Transfer(msg.sender,_to,_amount);
50         return true;
51     }
52   
53     function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
54         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
55         balances[_from]-=_amount;
56         allowed[_from][msg.sender]-=_amount;
57         balances[_to]+=_amount;
58         emit Transfer(_from, _to, _amount);
59         return true;
60     }
61   
62     function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
63         allowed[msg.sender][_spender]=_amount;
64         emit Approval(msg.sender, _spender, _amount);
65         return true;
66     }
67     
68     function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
69       return allowed[_owner][_spender];
70     }
71 }
72 
73 contract COPS_FINANCE is Token{
74     
75     constructor() public{
76         symbol = "COPS";
77         name = "copsfinance.com";
78         decimals = 18;
79         totalSupply = 18000000000000000000000;  
80         owner = msg.sender;
81         balances[owner] = totalSupply;
82     }
83     
84     receive () payable external {
85         require(msg.value>0);
86         owner.transfer(msg.value);
87     }
88 }