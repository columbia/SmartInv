1 pragma solidity ^0.4.16;
2 
3 interface token { // Интерфейс токена 
4     function totalSupply() constant public returns (uint256 _totalSupply); 
5     function balanceOf(address _owner) public constant returns (uint balance); 
6     function transfer(address _to, uint256 _value) public returns (bool success); 
7     function serviceTransfer(address _to, uint256 _value) public returns (bool success);
8 }
9 
10 contract Ownable {
11     address public owner;
12     
13     function Ownable() public { 
14         owner = msg.sender;
15     }
16  
17     modifier onlyOwner() { 
18         require(msg.sender == owner);
19         _;
20     }
21  
22     function transferOwnership(address _owner) public onlyOwner { 
23         owner = _owner;
24     }
25     
26 }
27 
28 contract RobotCoinSeller is Ownable{
29 
30     token  public robotCoin;
31     uint256 public salePrice; 
32     
33     uint public start;
34     uint public period;  
35 
36     bool public saleIsOn;
37 
38     function setSaleState(bool _saleIsOn) public onlyOwner{
39     saleIsOn = _saleIsOn;
40   }
41     
42 
43     function RobotCoinSeller () public { 
44         robotCoin = token(0x472B07087BBfE6689CA519e4fDcDEb499C5F8b76); 
45         salePrice = 1000000000000000;
46         start = 1518652800;
47         period = 89;
48         saleIsOn = false;
49     }
50         
51     function setSaleTime(uint newStart, uint newPeriod) public onlyOwner{
52       start = newStart;
53       period = newPeriod;
54     }
55         
56     function setRobotCoinContract(address newRobotCoin) public onlyOwner { 
57         robotCoin = token(newRobotCoin);
58     }
59 
60     function setSalePrice(uint256 newSalePrice) public onlyOwner { 
61         salePrice = newSalePrice;
62     }
63 
64     function() external payable { 
65         require(now > start && now < start + period*24*60*60);
66         require(saleIsOn);
67         robotCoin.serviceTransfer(msg.sender, msg.value * 1000 / salePrice );
68     }
69 
70     function transferEther(uint256 etherAmmount) public onlyOwner{ 
71         require(this.balance >= etherAmmount); 
72         owner.transfer(etherAmmount); 
73     }
74 
75 }