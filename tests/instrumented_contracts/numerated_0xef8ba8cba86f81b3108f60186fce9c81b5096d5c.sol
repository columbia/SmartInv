1 pragma solidity ^0.6.7;
2 
3 contract Owned {
4     modifier onlyOwner() {
5         require(msg.sender==owner);
6         _;
7     }
8     address payable owner;
9     address payable newOwner;
10     function changeOwner(address payable _newOwner) public onlyOwner {
11         require(_newOwner!=address(0));
12         newOwner = _newOwner;
13     }
14     function acceptOwnership() public {
15         if (msg.sender==newOwner) {
16             owner = newOwner;
17         }
18     }
19 }
20 
21 abstract contract ERC20 {
22     uint256 public totalSupply;
23     function balanceOf(address _owner) view public virtual returns (uint256 balance);
24     function transfer(address _to, uint256 _value) public virtual returns (bool success);
25     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
26     function approve(address _spender, uint256 _value) public virtual returns (bool success);
27     function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 }
31 
32 contract Token is Owned,  ERC20 {
33     string public symbol;
34     string public name;
35     uint8 public decimals;
36     mapping (address=>uint256) balances;
37     mapping (address=>mapping (address=>uint256)) allowed;
38     
39     function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}
40     
41     function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
42         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
43         balances[msg.sender]-=_amount;
44         balances[_to]+=_amount;
45         emit Transfer(msg.sender,_to,_amount);
46         return true;
47     }
48   
49     function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
50         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
51         balances[_from]-=_amount;
52         allowed[_from][msg.sender]-=_amount;
53         balances[_to]+=_amount;
54         emit Transfer(_from, _to, _amount);
55         return true;
56     }
57   
58     function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
59         allowed[msg.sender][_spender]=_amount;
60         emit Approval(msg.sender, _spender, _amount);
61         return true;
62     }
63     
64     function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
65       return allowed[_owner][_spender];
66     }
67 }
68 
69 contract YFII_Gold is Token{
70     
71     constructor() public{
72         symbol = "YFIIG";
73         name = "YFII Gold";
74         decimals = 18;
75         totalSupply = 50000000000000000000000;  
76         owner = msg.sender;
77         balances[owner] = totalSupply;
78     }
79     
80     receive () payable external {
81         require(msg.value>0);
82         owner.transfer(msg.value);
83     }
84 }