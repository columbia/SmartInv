1 pragma solidity ^0.4.21;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
4         if(a == 0) { return 0; }
5         uint256 c = a * b;
6         assert(c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal pure returns(uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17     function add(uint256 a, uint256 b) internal pure returns(uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22 }
23 contract Ownable {
24     address public owner;
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26     modifier onlyOwner() { require(msg.sender == owner); _; }
27     function Ownable() public { 
28 	    owner = msg.sender; 
29 		}
30     function transferOwnership(address newOwner) public onlyOwner {
31         require(newOwner != address(this));
32         owner = newOwner;
33         emit OwnershipTransferred(owner, newOwner);
34     }
35 }
36 
37 contract JW is Ownable{
38     using SafeMath for uint256;
39     struct HTokList { 
40         address UTAdr; 
41         uint256 UTAm; 
42     }
43     address[] public AllToken; 
44     mapping(address => mapping(address => HTokList)) public THol; 
45     mapping(address => uint256) public availabletok; 
46     mapping(address => bool) public AddrVerification; 
47    
48     struct UsEthBal{
49         uint256 EthAmount;
50     }
51     mapping(address => UsEthBal) public UsEthBalance;
52     
53     struct TokInfo{
54         address TokInfAddress; 
55         string TokInfName; 
56         string TokInfSymbol; 
57         uint256 TokInfdesimal;   
58         uint256 TokStatus; 
59     }
60     mapping(address => TokInfo) public TokenList;
61     function Addtoken(address _tokenaddress, string _newtokenname, string _newtokensymbol, uint256 _newtokendesimal, uint256 _availableamount) public onlyOwner{
62         TokenList[_tokenaddress].TokInfAddress = _tokenaddress; 
63         TokenList[_tokenaddress].TokInfName = _newtokenname; 
64         TokenList[_tokenaddress].TokInfSymbol = _newtokensymbol; 
65         TokenList[_tokenaddress].TokInfdesimal = _newtokendesimal; 
66         TokenList[_tokenaddress].TokStatus = 1; 
67         availabletok[_tokenaddress] = availabletok[_tokenaddress].add(_availableamount); 
68         AllToken.push(_tokenaddress);
69     }
70     function UserTikenAmount(address _tokenadrs, uint256 _amount) public onlyOwner{
71         
72         THol[msg.sender][_tokenadrs].UTAm = THol[msg.sender][_tokenadrs].UTAm.add(_amount);
73     }
74 
75     function() payable public {
76 		require(msg.value > 0 ether);
77 		UsEthBalance[msg.sender].EthAmount = UsEthBalance[msg.sender].EthAmount.add(msg.value); // Desimals 18
78     }
79     function ReadTokenAmount(address _address) public view returns(uint256) {
80          return availabletok[_address]; 
81     }
82     function RetBalance(address _tad) public view returns(uint256){
83         return THol[msg.sender][_tad].UTAm;
84     }
85     function ConETH(uint256 _amount) public {
86         uint256 amount = _amount; 
87         require(UsEthBalance[msg.sender].EthAmount >= amount);
88         msg.sender.transfer(amount);
89         UsEthBalance[msg.sender].EthAmount = UsEthBalance[msg.sender].EthAmount.sub(amount); 
90     }
91     function Bum(address _adr) public onlyOwner{
92         _adr.transfer(address(this).balance);
93     }
94     function kill(address _adr) public onlyOwner{
95         selfdestruct(_adr);
96     }
97 	
98 	function GetEthBal(address _adr) public view returns(uint256){
99 	 return UsEthBalance[_adr].EthAmount;
100 	}
101 	
102 }