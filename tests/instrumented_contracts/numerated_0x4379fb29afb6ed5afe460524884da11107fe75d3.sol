1 pragma solidity ^0.4.18;
2 contract ERC20 {
3   function totalSupply() constant public returns (uint totalsupply);
4   function balanceOf(address _owner) constant public returns (uint balance);
5   function transfer(address _to, uint _value) public returns (bool success);
6   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
7   function approve(address _spender, uint _value) public returns (bool success);
8   function allowance(address _owner, address _spender) constant public returns (uint remaining);
9   event Transfer(address indexed _from, address indexed _to, uint _value);
10   event Approval(address indexed _owner, address indexed _spender, uint _value);
11 }
12 contract Owned {
13   address public owner;
14   event OwnershipTransferred(address indexed _from, address indexed _to);
15   function Owned() public {
16     owner = msg.sender;
17   }
18   modifier onlyOwner {
19     if (msg.sender != owner) revert();
20     _;
21   }
22   function transferOwnership(address newOwner) onlyOwner public {
23     OwnershipTransferred(owner, newOwner);
24     owner = newOwner;
25   }
26 }
27 contract Tokenz is Owned {
28   address public token;
29   uint256 public inRate;
30   uint256 public outRate;
31   uint256 public minRate;
32   uint256 public minLot;
33   uint256 public leveRage;
34   event Received(address indexed user, uint256 ethers, uint256 tokens);
35   event Sent(address indexed user, uint256 ethers, uint256 tokens);
36   function Tokenz (
37     address _token,
38     uint256 _inRate,
39     uint256 _outRate,
40     uint256 _minRate,
41     uint256 _minLot,
42     uint256 _leveRage
43   ) public {
44   	token=_token;
45   	inRate=_inRate;
46   	outRate=_outRate;
47   	minRate=_minRate;
48   	minLot=_minLot;
49   	leveRage=_leveRage;
50   }
51   function WithdrawToken(address tokenAddress, uint256 tokens) onlyOwner public {
52     if (!ERC20(tokenAddress).transfer(owner, tokens)) revert();
53   }
54   function WithdrawEther(uint256 ethers) onlyOwner public {
55     if (this.balance<ethers) revert();
56     if (!owner.send(ethers)) revert();
57   }
58   function SetInRate (uint256 newrate) onlyOwner public {inRate=newrate;}
59   function SetOutRate (uint256 newrate) onlyOwner public {outRate=newrate;}
60   function ChangeToken (address newtoken) onlyOwner public {
61     if (newtoken==0x0) revert();
62     token=newtoken;
63   }
64   function SetLot (uint256 newlot) onlyOwner public {
65     if (newlot<=0) revert();
66     minLot=newlot;
67   }
68   function TokensIn(uint256 tokens) public {
69     if (inRate==0) revert();
70     uint256 maxtokens=this.balance/inRate;
71     if (tokens>maxtokens) tokens=maxtokens;
72     if (tokens==0) revert();
73     if (!ERC20(token).transferFrom(msg.sender, address(this), tokens)) revert();
74     uint256 sum = tokens*inRate;
75     if (!msg.sender.send(sum)) revert();
76     uint256 newrate = inRate-tokens*leveRage;
77     if (newrate>=minRate) {
78       inRate=newrate;
79       outRate=outRate-tokens*leveRage;	
80     }
81     Received(msg.sender, sum, tokens);
82   }
83   function TokensOut() payable public {
84     if (outRate==0) revert();
85     uint256 tokens=msg.value/outRate;
86     if (tokens<minLot) revert();
87     uint256 total=ERC20(token).balanceOf(address(this));
88     if (total<=0) revert();
89     uint256 change=0;
90     uint256 maxeth=total*outRate;
91     if (msg.value>maxeth) change=msg.value-maxeth;
92     if (change>0) if (!msg.sender.send(change)) revert();
93     if (!ERC20(token).transfer(msg.sender, tokens)) revert();
94     outRate=outRate+tokens*leveRage;
95     inRate=inRate+tokens*leveRage;
96     Sent(msg.sender, msg.value, tokens);
97   }
98   function () payable public {TokensOut();}
99 }