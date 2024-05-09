1 pragma solidity ^0.4.24;
2 
3 contract OCCC {
4     
5     string public name;
6     string public symbol;
7     //the circulation limit of token
8     uint256 public totalSupply;
9     //decimal setting
10     uint8 public decimals = 18;
11     
12     //contract admin's address
13     address private admin_add;
14     //new user can get money when first register
15     uint private present_money=0;
16     
17     //transfer event
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     //save the msg of contract_users
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowances;
23     
24     // constructor
25     constructor(uint256 limit,string token_name,string token_symbol,uint8 token_decimals) public {
26         admin_add=msg.sender;
27         name=token_name;
28         symbol=token_symbol;
29         totalSupply=limit * 10 ** uint256(decimals);
30         decimals=token_decimals;
31         
32         balanceOf[admin_add]=totalSupply;
33     }
34     
35     //for admin user to change present_money
36     function setPresentMoney (uint money) public{
37         address opt_user=msg.sender;
38         if(opt_user == admin_add){
39             present_money = money;
40         }
41     }
42     
43     //add new user to contract
44     function approve(address _spender, uint256 value) public returns (bool success){
45         allowances[msg.sender][_spender] = value;
46         return true;
47     }
48     
49     function allowance(address _owner, address _spender) constant public returns (uint256 remaining){
50         return allowances[_owner][_spender];
51     }
52     
53     //admin account transfer money to users
54     function adminSendMoneyToUser(address to,uint256 value) public{
55         address opt_add=msg.sender;
56         if(opt_add == admin_add){
57             transferFrom(admin_add,to,value);
58         }
59     }
60     
61     //burn account hold money
62     function burnAccountMoeny(address add,uint256 value) public{
63         address opt_add=msg.sender;
64         require(opt_add == admin_add);
65         require(balanceOf[add]>value);
66         
67         balanceOf[add]-=value;
68         totalSupply -=value;
69     }
70 
71     function transfer(address _to, uint256 _value) public returns (bool success){
72 
73         return _transferAct(msg.sender,_to,_value);
74     }
75 
76     //transfer action between users
77     function transferFrom(address from,address to,uint256 value) public returns (bool success){
78         
79         require(value <= allowances[from][msg.sender]);     // Check allowance
80         allowances[from][msg.sender] -= value;
81         
82         return _transferAct(from,to,value);
83     }
84     
85     function _transferAct(address from,address to,uint256 value) public returns (bool success){
86         //sure target no be 0x0
87         require(to != 0x0);
88         //check balance of sender
89         require(balanceOf[from] >= value);
90         //sure the amount of the transfer is greater than 0
91         require(balanceOf[to] + value >= balanceOf[to]);
92         
93         uint previousBalances = balanceOf[from] + balanceOf[to];
94         balanceOf[from] -= value;
95         balanceOf[to] += value;
96         
97         emit Transfer(from,to,value);
98         
99         assert(balanceOf[from] + balanceOf[to] == previousBalances);
100         return true;
101     }
102     
103     //view balance
104     function balanceOf(address _owner) public view returns(uint256 balance){
105         return balanceOf[_owner];
106     }
107 
108 }