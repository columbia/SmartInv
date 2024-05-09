1 pragma solidity >=0.4.0 <0.6.0;
2 
3 contract owned {
4     address public owner;
5     address public manager;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 }
16 
17 contract Coin {
18     function getOwner(uint index) public view returns (address, uint256);
19     function getOwnerCount() public view returns (uint);
20 }
21 
22 contract RTDAirdrop is owned{
23     event console(address addr, uint256 amount);
24     event AirDrop(address indexed from, address indexed to, uint256 value);
25     string public detail;
26     uint public eth_price_per_usd;
27     uint public rtd_price_per_eth;
28     uint public date_start;
29     uint public date_end;
30     uint public active_round;
31 
32     struct Member {
33         uint256 have_rtd;
34         uint256 dividend;
35         uint take;
36     }
37 
38     struct Round {
39         string detail;
40         uint eth_price_per_usd;
41         uint rtd_price_per_eth;
42         uint date_start;
43         uint date_end;
44         mapping(address => Member) members;
45     }
46 
47     Round[] public round;
48 
49 
50     function setting( string memory new_detail, uint new_eth_price_per_usd, uint new_rtd_price_per_eth, uint new_date_start, uint new_date_end ) onlyOwner public {
51 
52             detail = new_detail;
53             eth_price_per_usd = new_eth_price_per_usd;
54             rtd_price_per_eth = new_rtd_price_per_eth;
55             date_start = new_date_start;
56             date_end = new_date_end;
57             active_round = round.length;
58 
59             round[active_round]=Round(detail,eth_price_per_usd,rtd_price_per_eth,date_start,date_end);
60             Coin c = Coin(0x003FfEFeFBC4a6F34a62A3cA7b7937a880065BCB);
61             for (uint256 i = 0; i < c.getOwnerCount(); i++) {
62                 address addr;
63                 uint256 amount;
64                 (addr, amount)  = c.getOwner(i);
65                 round[active_round].members[addr] = Member(amount,(amount * (eth_price_per_usd * rtd_price_per_eth)),0);
66             } 
67 
68     }
69 
70 
71     function getAirDrop() public {
72         require (now >= date_start);  
73         require (now <= date_end);  
74         require (msg.sender != address(0x0));                
75         if(round[active_round].members[msg.sender].take==0){
76             round[active_round].members[msg.sender].take=1;
77             //msg.sender.transfer(members[msg.sender].dividend);
78             emit AirDrop(0x003FfEFeFBC4a6F34a62A3cA7b7937a880065BCB, msg.sender, round[active_round].members[msg.sender].dividend);
79         }
80     }
81 }