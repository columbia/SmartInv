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
27 contract SellERC20Token is Owned {
28   address public token;
29   uint256 public sellPrice;
30   uint256 public minLot;
31   event TokensBought(address indexed buyer, uint256 ethersSent, uint256 tokensBought);
32   event TradeStatus(address indexed owner, address indexed token, uint256 price, uint256 lot);
33   function SellERC20Token (
34     address _token,
35     uint256 _sellPrice,
36     uint256 _minLot
37   ) public {
38   	token=_token;
39   	sellPrice=_sellPrice;
40   	minLot=_minLot;
41   }
42   function WithdrawToken(uint256 tokens) onlyOwner public returns (bool ok) {
43     return ERC20(token).transfer(owner, tokens);
44   }
45   function WithdrawEther(uint256 ethers) onlyOwner public returns (bool ok) {
46     if (this.balance>=ethers) return owner.send(ethers);
47   }
48   function SetPrice (uint256 newprice) onlyOwner public {
49     sellPrice = newprice;
50     TradeStatus(owner,token,sellPrice,minLot);
51   }
52   function ChangeToken (address newtoken) onlyOwner public {
53     if (newtoken==0x0) revert();
54     token=newtoken;
55     TradeStatus(owner,token,sellPrice,minLot);
56   }
57   function SetLot (uint256 newlot) onlyOwner public {
58     if (newlot<=0) revert();
59     minLot=newlot;
60     TradeStatus(owner,token,sellPrice,minLot);
61   }
62   function SellToken() payable public {
63     uint tokens=msg.value/sellPrice;
64     if (tokens<minLot) revert();
65     uint total=ERC20(token).balanceOf(address(this));
66     uint256 change=0;
67     uint256 maxeth=total*sellPrice;
68     if (msg.value>maxeth) change=msg.value-maxeth;
69     if (change>0) if (!msg.sender.send(change)) revert();
70     if (!ERC20(token).transfer(msg.sender, tokens)) revert();
71     TokensBought(msg.sender, msg.value, tokens);
72     TradeStatus(owner,token,sellPrice,minLot);
73   }
74   function () payable public {SellToken();}
75 }