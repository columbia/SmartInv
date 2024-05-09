1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4   function totalSupply() constant public returns (uint totalsupply);
5   function balanceOf(address _owner) constant public returns (uint balance);
6   function transfer(address _to, uint _value) public returns (bool success);
7   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
8   function approve(address _spender, uint _value) public returns (bool success);
9   function allowance(address _owner, address _spender) constant public returns (uint remaining);
10   event Transfer(address indexed _from, address indexed _to, uint _value);
11   event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 contract Owned {
15   address public owner;
16   event OwnershipTransferred(address indexed _from, address indexed _to);
17 
18   function Owned() public {
19     owner = msg.sender;
20   }
21 
22   modifier onlyOwner {
23     if (msg.sender != owner) revert();
24     _;
25   }
26 
27   function transferOwnership(address newOwner) onlyOwner public {
28     OwnershipTransferred(owner, newOwner);
29     owner = newOwner;
30   }
31 }
32 
33 contract SellKiCoin is Owned {
34   address public constant payto1=0x4dF46817dc0e8dD69D7DA51b0e2347f5EFdB9671;
35   address public constant payto2=0xd58f863De3bb877F24996291cC3C659b3550d58e;
36   address public constant payto3=0x574c4DB1E399859753A09D65b6C5586429663701;
37   address public constant token=0x8b0e368aF9d27252121205B1db24d9E48f62B236;
38   uint256 public constant share1=800;
39   uint256 public constant share2=100;
40   uint256 public constant share3=5;
41   uint256 public sellPrice=2122* 1 szabo;
42   uint256 public minLot=5;
43 	
44   event GotTokens(address indexed buyer, uint256 ethersSent, uint256 tokensBought);
45 	
46   function SellKiCoin () public {}
47     
48   function WithdrawToken(uint256 tokens) onlyOwner public returns (bool ok) {
49     return ERC20(token).transfer(owner, tokens);
50   }
51     
52   function SetPrice (uint256 newprice) onlyOwner public {
53     sellPrice = newprice * 1 szabo;
54   }
55   
56   function SetMinLot (uint256 newminlot) onlyOwner public {
57     if (newminlot>=5) minLot = newminlot;
58     else revert();
59   }
60     
61   function WithdrawEther(uint256 ethers) onlyOwner public returns (bool ok) {
62     if (this.balance >= ethers) {
63       return owner.send(ethers);
64     }
65   }
66     
67   function BuyToken() payable public {
68     uint tokens = msg.value / sellPrice;
69     uint total = ERC20(token).balanceOf(address(this));
70     uint256 change = 0;
71     uint256 maxethers = total * sellPrice;
72     if (msg.value > maxethers) {
73       change  = msg.value - maxethers;
74     }
75     if (change > 0) {
76       if (!msg.sender.send(change)) revert();
77     }
78     if (tokens > minLot) {
79       if (!ERC20(token).transfer(msg.sender, tokens)) revert();
80       else {
81         if (!payto1.send(msg.value*share1/1000)) revert();
82         else if (!payto2.send(msg.value*share2/1000)) revert();
83         else if (!payto3.send(msg.value*share3/1000)) revert();
84         GotTokens(msg.sender, msg.value, tokens);
85       }
86     }
87   }
88     
89   function () payable public {
90     BuyToken();
91   }
92 }