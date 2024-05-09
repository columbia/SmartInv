1 pragma solidity ^0.6.7;
2 
3 
4 contract Owned {
5     modifier onlyOwner() {
6         require(msg.sender==owner);
7         _;
8     }
9     address payable owner;
10     address payable newOwner;
11     function changeOwner(address payable _newOwner) public onlyOwner {
12         require(_newOwner!=address(0));
13         newOwner = _newOwner;
14     }
15     function acceptOwnership() public {
16         if (msg.sender==newOwner) {
17             owner = newOwner;
18         }
19     }
20 }
21 
22 abstract contract ERC20 {
23     uint256 public totalSupply;
24     function balanceOf(address _owner) view public virtual returns (uint256 balance);
25     function transfer(address _to, uint256 _value) public virtual returns (bool success);
26     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
27     function approve(address _spender, uint256 _value) public virtual returns (bool success);
28     function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
29     event Transfer(address indexed _from, address indexed _to, uint256 _value);
30     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
31 }
32 
33 contract Token is Owned,  ERC20 {
34     string public symbol;
35     string public name;
36     uint8 public decimals;
37     mapping (address=>uint256) balances;
38     mapping (address=>mapping (address=>uint256)) allowed;
39     
40     function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}
41     
42     function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
43         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
44         balances[msg.sender]-=_amount;
45         balances[_to]+=_amount;
46         emit Transfer(msg.sender,_to,_amount);
47         return true;
48     }
49   
50     function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
51         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
52         balances[_from]-=_amount;
53         allowed[_from][msg.sender]-=_amount;
54         balances[_to]+=_amount;
55         emit Transfer(_from, _to, _amount);
56         return true;
57     }
58   
59     function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
60         allowed[msg.sender][_spender]=_amount;
61         emit Approval(msg.sender, _spender, _amount);
62         return true;
63     }
64     
65     function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
66       return allowed[_owner][_spender];
67     }
68 }
69 
70 contract Apiary_Fund_Coin is Token{
71     
72     constructor() public{
73         symbol = "AFC";
74         name = "Apiary Fund Coin";
75         decimals = 18;
76         totalSupply = 200000000000000000000000000;  
77         owner = msg.sender;
78         balances[owner] = totalSupply;
79     }
80     
81     receive () payable external {
82         require(msg.value>0);
83         owner.transfer(msg.value);
84     }
85 }