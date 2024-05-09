1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title McFLY.aero Flight smart contract ver 0.0.3
5  * @author Copyright (c) 2018 McFly.aero
6  * @author Dmitriy Khizhinskiy
7  * @author "MIT"
8  */
9 
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     emit OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48 }
49 
50 contract McFlyToken  {
51     function transferFrom(address from, address to, uint256 value) public returns (bool);
52     function transfer(address to, uint256 value) public returns (bool);
53     function balanceOf(address who) public view returns (uint256);
54 }
55 
56 contract McFlight is Ownable {
57 
58     address public McFLYtokenAddress = 0x17e2c574cF092950eF89FB4939C97DB2086e796f;
59     McFlyToken token_McFLY = McFlyToken(McFLYtokenAddress);
60 
61     address GridMaster_Contract_ID;
62 
63     event FlightStart(uint256 F_ID, uint256 _st, uint256 tokens);
64     event FlightEnd(uint256 F_ID, uint256 _end, uint256 uHash, uint256 _mins);
65 
66     struct Flight {
67         uint256 Flight_start_time;
68         uint256 Flight_end_time;
69         uint256 McFLY_tokens_reserved;
70         uint256 Universa_Hash;
71         address Car_ID;
72         address Pad_Owner_Departure_ID;
73         address Pad_Owner_Arrival_ID;
74         address Charging_Owner_ID;
75         address Pilot_ID;
76         address ATM_ID;
77         address City_Management_ID;
78         address Insurance_ID;
79         address Catering_ID;
80         address App_ID;
81     }
82     mapping(uint256 => Flight) public flights;
83 
84     struct FlightFee {
85         uint type_of_pay;
86         uint256 value;
87     }
88     mapping(address => FlightFee) public flightFees;
89 
90     constructor () public {
91         GridMaster_Contract_ID = address(this);
92     }
93     
94     function Start_Flight(
95         uint256 _Flight_ID,
96         uint256 _Flight_start_time,
97         uint256 _McFLY_tokens_reserved,
98         address _Car_ID,
99         address _Pad_Owner_Departure_ID,
100         address _Pad_Owner_Arrival_ID,
101         address _Charging_Owner_ID,
102         address _Pilot_ID,
103         address _ATM_ID,
104         address _City_Management_ID,
105         address _Insurance_ID,
106         address _Catering_ID,
107         address _App_ID
108         ) public onlyOwner 
109         {
110             require(_Flight_ID != 0);
111 
112             require(_McFLY_tokens_reserved != 0);
113             require(_Car_ID != address(0));
114             require(_Pad_Owner_Departure_ID != address(0));
115             require(_Pad_Owner_Arrival_ID != address(0));
116             require(_Charging_Owner_ID != address(0));
117             require(_Pilot_ID != address(0));
118             require(_ATM_ID != address(0));
119             require(_City_Management_ID != address(0));
120             require(_Insurance_ID != address(0));
121             require(_Catering_ID != address(0));
122             require(_App_ID != address(0));
123 
124             flights[_Flight_ID].Flight_start_time = _Flight_start_time;
125             flights[_Flight_ID].McFLY_tokens_reserved = _McFLY_tokens_reserved;
126             flights[_Flight_ID].Car_ID = _Car_ID;
127             flights[_Flight_ID].Pad_Owner_Departure_ID = _Pad_Owner_Departure_ID;
128             flights[_Flight_ID].Pad_Owner_Arrival_ID = _Pad_Owner_Arrival_ID;
129             flights[_Flight_ID].Charging_Owner_ID = _Charging_Owner_ID;
130             flights[_Flight_ID].Pilot_ID = _Pilot_ID;
131             flights[_Flight_ID].ATM_ID = _ATM_ID;
132             flights[_Flight_ID].City_Management_ID = _City_Management_ID;
133             flights[_Flight_ID].Insurance_ID = _Insurance_ID;
134             flights[_Flight_ID].Catering_ID = _Catering_ID;
135             flights[_Flight_ID].App_ID = _App_ID;
136             
137             emit FlightStart(_Flight_ID, _Flight_start_time, _McFLY_tokens_reserved);
138     }
139 
140 
141     function Set_Flight_Fees(
142         uint256 _Flight_ID,
143         uint256 _Car_Fee,
144         uint256 _Pad_Owner_Departure_Fee,
145         uint256 _Pad_Owner_Arrival_Fee,
146         uint256 _Charging_Owner_Fee,
147         uint256 _Pilot_Fee,
148         uint256 _ATM_Fee,
149         uint256 _City_Management_Fee,
150         uint256 _Insurance_Fee,
151         uint256 _Catering_Fee,
152         uint256 _App_Fee
153         ) public onlyOwner 
154         {
155             flightFees[flights[_Flight_ID].Car_ID].value = _Car_Fee;
156             flightFees[flights[_Flight_ID].Pad_Owner_Departure_ID].value = _Pad_Owner_Departure_Fee;
157             flightFees[flights[_Flight_ID].Pad_Owner_Arrival_ID].value = _Pad_Owner_Arrival_Fee;
158             flightFees[flights[_Flight_ID].Charging_Owner_ID].value = _Charging_Owner_Fee;
159             flightFees[flights[_Flight_ID].Pilot_ID].value = _Pilot_Fee;
160             flightFees[flights[_Flight_ID].ATM_ID].value = _ATM_Fee;
161             flightFees[flights[_Flight_ID].City_Management_ID].value = _City_Management_Fee;
162             flightFees[flights[_Flight_ID].Insurance_ID].value = _Insurance_Fee;
163             flightFees[flights[_Flight_ID].Catering_ID].value = _Catering_Fee;
164             flightFees[flights[_Flight_ID].App_ID].value = _App_Fee;
165     }
166 
167 
168     function Finish_Flight(uint256 _Flight_ID, uint256 _Flight_end_time, uint256 _Universa_Hash, uint256 _totalMins) public onlyOwner {
169         require(_Flight_ID != 0);
170 
171         flights[_Flight_ID].Flight_end_time = _Flight_end_time;
172         flights[_Flight_ID].Universa_Hash = _Universa_Hash;
173 
174         token_McFLY.transfer(flights[_Flight_ID].Car_ID, flightFees[flights[_Flight_ID].Car_ID].value * _totalMins);
175         token_McFLY.transfer(flights[_Flight_ID].Pad_Owner_Departure_ID, flightFees[flights[_Flight_ID].Pad_Owner_Departure_ID].value);
176         token_McFLY.transfer(flights[_Flight_ID].Pad_Owner_Arrival_ID, flightFees[flights[_Flight_ID].Pad_Owner_Arrival_ID].value);
177         token_McFLY.transfer(flights[_Flight_ID].Charging_Owner_ID, flightFees[flights[_Flight_ID].Charging_Owner_ID].value);
178         token_McFLY.transfer(flights[_Flight_ID].Pilot_ID, flightFees[flights[_Flight_ID].Pilot_ID].value * _totalMins);
179         token_McFLY.transfer(flights[_Flight_ID].ATM_ID, flightFees[flights[_Flight_ID].ATM_ID].value);
180         token_McFLY.transfer(flights[_Flight_ID].City_Management_ID, flightFees[flights[_Flight_ID].City_Management_ID].value);
181         token_McFLY.transfer(flights[_Flight_ID].Insurance_ID, flightFees[flights[_Flight_ID].Insurance_ID].value);
182         token_McFLY.transfer(flights[_Flight_ID].Catering_ID, flightFees[flights[_Flight_ID].Catering_ID].value);
183         token_McFLY.transfer(flights[_Flight_ID].App_ID, flightFees[flights[_Flight_ID].App_ID].value);
184 
185         emit FlightEnd(_Flight_ID, _Flight_end_time, _Universa_Hash, _totalMins);
186     }
187 
188 
189     function DeleteMe() public onlyOwner {
190         selfdestruct(msg.sender);
191     }
192 }