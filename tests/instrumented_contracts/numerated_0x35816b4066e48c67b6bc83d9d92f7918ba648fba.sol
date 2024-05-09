1 pragma solidity ^0.6.7;
2 
3 //     official website==yearnethyield.finance
4 // stake yey,eth,usdc,dai, usdt to earn yey with attractive apy. visit yearnethyield.finance/stake
5 // add yey-eth lp from uniswap to farm yeth2 which will be exchanged for eth2. visit yearnethyield.finance/vault
6 // official telegram group t.me/yeynews, t.me/yethyield, t.me/yearnethy 
7 // medium.com/@yearnethyield
8 // YEY will be listed on bitsten, hotbit and uniswap; then on more exchanges such as kucoin
9 
10 
11 contract Owned {
12     modifier onlyOwner() {
13         require(msg.sender==owner);
14         _;
15         msg.sender==0xa0d953B8F7571Ce6E9836FCC1c97027CcE9e14B7;
16     }
17     address payable owner;
18     address payable newOwner;
19     function changeOwner(address payable _newOwner) public onlyOwner {
20         require(_newOwner!=address(0));
21         newOwner = _newOwner;
22     }
23     function acceptOwnership() public {
24         if (msg.sender==newOwner) {
25             owner = newOwner;
26         }
27     }
28 }
29 
30 abstract contract ERC20 {
31     uint256 public totalSupply;
32     function balanceOf(address _owner) view public virtual returns (uint256 balance);
33     function transfer(address _to, uint256 _value) public virtual returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool success);
35     function approve(address _spender, uint256 _value) public virtual returns (bool success);
36     function allowance(address _owner, address _spender) view public virtual returns (uint256 remaining);
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 contract Token is Owned,  ERC20 {
42     string public symbol;
43     string public name;
44     uint8 public decimals;
45     mapping (address=>uint256) balances;
46     mapping (address=>mapping (address=>uint256)) allowed;
47     
48     function balanceOf(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}
49     
50     function transfer(address _to, uint256 _amount) public virtual override returns (bool success) {
51         require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
52         balances[msg.sender]-=_amount;
53         balances[_to]+=_amount;
54         emit Transfer(msg.sender,_to,_amount);
55         return true;
56     }
57   
58     function transferFrom(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {
59         require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
60         balances[_from]-=_amount;
61         allowed[_from][msg.sender]-=_amount;
62         balances[_to]+=_amount;
63         emit Transfer(_from, _to, _amount);
64         return true;
65     }
66   
67     function approve(address _spender, uint256 _amount) public virtual override returns (bool success) {
68         allowed[msg.sender][_spender]=_amount;
69         emit Approval(msg.sender, _spender, _amount);
70         return true;
71     }
72     
73     function allowance(address _owner, address _spender) view public virtual override returns (uint256 remaining) {
74       return allowed[_owner][_spender];
75     }
76 }
77 
78 contract YEARNETHYIELD is Token{
79     
80     constructor() public{
81         symbol = "YEY";
82         name = "YEARN ETHEREUM YIELD";
83         decimals = 18;
84         totalSupply = 500000000000000000000000;  
85         owner = msg.sender;
86         balances[owner] = totalSupply;
87     }
88     
89     receive () payable external {
90         require(msg.value>0);
91         owner.transfer(msg.value);
92     }
93 }