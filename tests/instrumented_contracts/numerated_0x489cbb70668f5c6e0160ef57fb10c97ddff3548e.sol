1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function decimals() public view returns (uint);
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 contract Ownable {
28   address public owner;
29 
30 
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) public onlyOwner {
55     require(newOwner != address(0));
56     emit OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 
60 }
61 
62 contract TokenLocker is Ownable {
63     
64     ERC20 public token = ERC20(0x611171923b84185e9328827CFAaE6630481eCc7a); // STM address
65     
66     // timestamp when token release is enabled
67     uint256 public releaseTimeFund = 1537833600; // 25 сентября 2018
68     uint256 public releaseTimeTeamAdvisorsPartners = 1552348800; // 12 марта 2019
69     
70     address public ReserveFund = 0xC5fed49Be1F6c3949831a06472aC5AB271AF89BD; // 18 600 000
71     uint public ReserveFundAmount = 18600000 ether;
72     
73     address public AdvisorsPartners = 0x5B5521E9D795CA083eF928A58393B8f7FF95e098; // 3 720 000
74     uint public AdvisorsPartnersAmount = 3720000 ether;
75     
76     address public Team = 0x556dB38b73B97954960cA72580EbdAc89327808E; // 4 650 000
77     uint public TeamAmount = 4650000 ether;
78     
79     function unlockFund () public onlyOwner {
80         require(releaseTimeFund <= block.timestamp);
81         require(ReserveFundAmount > 0);
82         uint tokenBalance = token.balanceOf(this);
83         require(tokenBalance >= ReserveFundAmount);
84         
85         if (token.transfer(ReserveFund, ReserveFundAmount)) {
86             ReserveFundAmount = 0;
87         }
88     }
89     
90     function unlockTeamAdvisorsPartnersTokens () public onlyOwner {
91         require(releaseTimeTeamAdvisorsPartners <= block.timestamp);
92         require(AdvisorsPartnersAmount > 0);
93         require(TeamAmount > 0);
94         uint tokenBalance = token.balanceOf(this);
95         require(tokenBalance >= AdvisorsPartnersAmount + TeamAmount);
96         
97         if (token.transfer(AdvisorsPartners, AdvisorsPartnersAmount)) {
98             AdvisorsPartnersAmount = 0;
99         }
100         
101         if (token.transfer(Team, TeamAmount)) {
102             TeamAmount = 0;
103         }
104     }
105 }