1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-07
3 */
4 
5 pragma solidity ^0.6.7;
6 
7 
8 contract Owned {
9     modifier onlyOwner() {
10         require(msg.sender==owner);
11         _;
12     }
13     address payable owner;
14     address payable newOwner;
15     function changeOwner(address payable _newOwner) public onlyOwner {
16         require(_newOwner!=address(0));
17         newOwner = _newOwner;
18     }
19     function acceptOwnership() public {
20         if (msg.sender==newOwner) {
21             owner = newOwner;
22         }
23     }
24 }
25 
26 abstract contract ERC20 {
27     uint256 public totalSupply;
28     function balanceOf(address _owner) view public virtual returns (uint256 balance);
29     function transfer(address _to, uint256 _value) public virtual returns (bool success);
30     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
31     function approve(address _spender, uint256 _value) public virtual returns (bool success);
32     function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 
37 contract Token is Owned,  ERC20 {
38     string public symbol;
39     string public name;
40     uint8 public decimals;
41     mapping (address=>uint256) balances;
42     mapping (address=>mapping (address=>uint256)) allowed;
43     
44     function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}
45     
46     function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
47         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
48         balances[msg.sender]-=_amount;
49         balances[_to]+=_amount;
50         emit Transfer(msg.sender,_to,_amount);
51         return true;
52     }
53   
54     function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
55         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
56         balances[_from]-=_amount;
57         allowed[_from][msg.sender]-=_amount;
58         balances[_to]+=_amount;
59         emit Transfer(_from, _to, _amount);
60         return true;
61     }
62   
63     function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
64         allowed[msg.sender][_spender]=_amount;
65         emit Approval(msg.sender, _spender, _amount);
66         return true;
67     }
68     
69     function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
70       return allowed[_owner][_spender];
71     }
72 }
73 
74 contract YFIW is Token{
75     
76     constructor() public{
77         symbol = "YFIW";
78         name = "YFIW.FINANCE";
79         decimals = 18;
80         totalSupply = 29330000000000000000000;  
81         owner = msg.sender;
82         balances[owner] = totalSupply;
83     }
84     
85     receive () payable external {
86         require(msg.value>0);
87         owner.transfer(msg.value);
88     }
89 }