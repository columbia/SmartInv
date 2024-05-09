1 pragma solidity ^0.4.18;
2 
3 contract BowdenCoin {
4 
5   uint8 Decimals = 6;
6   uint256 total_supply = 100 * 10**6;
7   address owner;
8   uint creation_block;
9 
10   function BowdenCoin() public{
11     owner = msg.sender;
12     balanceOf[msg.sender] = total_supply;
13     creation_block = block.number;
14   }
15 
16   event Transfer(address indexed _from, address indexed _to, uint256 value);
17   event Approval(address indexed _owner, address indexed _spender, uint256 value);
18   event DoubleSend(address indexed sender, address indexed recipient, uint256 value);
19   event NextDouble(address indexed _owner, uint256 date);
20   event Burn(address indexed burner, uint256 value);
21 
22   mapping (address => uint256) public balanceOf;
23   mapping (address => mapping (address => uint)) public allowance;
24   mapping (address => uint256) public nextDouble;
25 
26 
27   function name() pure public returns (string _name){
28     return "BowdenCoin";
29   }
30 
31   function symbol() pure public returns (string _symbol){
32     return "BDC";
33   }
34 
35   function decimals() view public returns (uint8 _decimals){
36     return Decimals;
37   }
38 
39   function totalSupply() public constant returns (uint256 total){
40       return total_supply;
41   }
42 
43   function balanceOf(address tokenOwner) public constant returns (uint256 balance){
44     return balanceOf[tokenOwner];
45   }
46 
47   function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining){
48     return allowance[tokenOwner][spender];
49   }
50 
51   function transfer(address recipient, uint256 value) public returns (bool success){
52     require(balanceOf[msg.sender] >= value);
53     require(balanceOf[recipient] + value >= balanceOf[recipient]);
54     balanceOf[msg.sender] -= value;
55     balanceOf[recipient] += value;
56     Transfer(msg.sender, recipient, value);
57 
58     if(nextDouble[msg.sender] > block.number && nextDouble[msg.sender] > nextDouble[recipient]){
59       nextDouble[recipient] = nextDouble[msg.sender];
60       NextDouble(recipient, nextDouble[recipient]);
61     }
62     return true;
63   }
64 
65   function approve(address spender, uint256 value) public returns (bool success){
66     allowance[msg.sender][spender] = value;
67     Approval(msg.sender, spender, value);
68     return true;
69   }
70 
71   function transferFrom(address from, address recipient, uint256 value) public
72       returns (bool success){
73     require(balanceOf[from] >= value);                                          //ensure from address has available balance
74     require(balanceOf[recipient] + value >= balanceOf[recipient]);              //stop overflow
75     require(value <= allowance[from][msg.sender]);                              //ensure msg.sender has enough allowance
76     balanceOf[from] -= value;
77     balanceOf[recipient] += value;
78     allowance[from][msg.sender] -= value;
79     Transfer(from, recipient, value);
80 
81     if(nextDouble[from] > block.number && nextDouble[from] > nextDouble[recipient]){
82       nextDouble[recipient] = nextDouble[from];
83       NextDouble(recipient, nextDouble[recipient]);
84     }
85     return true;
86   }
87 
88   function getDoublePeriod() view public returns (uint blocks){
89     require(block.number >= creation_block);
90     uint dp = ((block.number-creation_block)/60+1)*8;                           //goes up by 8 blocks every 60 blocks. Stars at 8
91     if(dp > 2 days) return 2 days;                                              //equivalent to one months worth of blocks since there is 1 block every 15 seconds
92     return dp;
93   }
94 
95   function canDouble(address tokenOwner) view public returns (bool can_double){
96     return nextDouble[tokenOwner] <= block.number;
97   }
98 
99   function remainingDoublePeriod(uint blockNum) view internal returns (uint){
100     if(blockNum <= block.number) return 0;
101     return blockNum - block.number;
102   }
103 
104   function getNextDouble(address tokenOwner) view public returns (uint256 blockHeight){
105     return nextDouble[tokenOwner];
106   }
107 
108   function doubleSend(uint256 value, address recipient) public
109       returns(bool success){
110     uint half_value = value/2;
111     require(total_supply + half_value + half_value >= total_supply);                      //totalSupply overflow check
112     require(balanceOf[msg.sender] + half_value >= balanceOf[msg.sender]);            //owner overflow check
113     require(balanceOf[recipient] + half_value >= balanceOf[recipient]);              //recipient overflow check
114     require(balanceOf[msg.sender] >= half_value);                            //ensure that owner has enough balance to double
115     require(canDouble(msg.sender));                                             //ensure that owner has the right to double
116     require(msg.sender != recipient);                                           //cant double and send to yourself
117 
118     balanceOf[msg.sender] += half_value;                                             //increase the balance of the function caller
119     balanceOf[recipient] += half_value;                                              //increase the balance of the recipient
120     DoubleSend(msg.sender, recipient, half_value);                                   //log the double send
121     total_supply += half_value + half_value;                                              //increase the total supply to match the new amount
122 
123     nextDouble[msg.sender] = block.number + getDoublePeriod();                  //set the time of next doubling to the current block plus the current delay
124     NextDouble(msg.sender, nextDouble[msg.sender]);                             //log the next doubling for msg.sender
125     nextDouble[recipient] = block.number + getDoublePeriod() + remainingDoublePeriod(nextDouble[recipient]);  //set the time of next doubling to the same as the msg.sender, plus any excess that was tied to the recipient
126     NextDouble(recipient, nextDouble[recipient]);                               //log
127 
128     return true;
129   }
130 
131   function withdrawEth() public returns(bool success){
132     require(msg.sender == owner);                                               //ensure the owner can only use this
133     owner.transfer(this.balance);                                               //transfer all eth to owner (failsafe incase eth is sent to this address)
134     return true;
135   }
136 
137   function burnToken(uint256 value) public returns (bool success){
138     require(balanceOf[msg.sender] >= value);                                    //must have enough in account to burn
139     require(total_supply - value <= total_supply);                              //check for underflow
140     balanceOf[msg.sender] -= value;
141     total_supply -= value;
142     Burn(msg.sender,value);
143     return true;
144   }
145 }