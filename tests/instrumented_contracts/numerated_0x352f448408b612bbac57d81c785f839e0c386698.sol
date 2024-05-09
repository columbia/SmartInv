1 pragma solidity ^0.4.6;
2 
3 //
4 //  This is an Ethereum Race ( and coder challenge )
5 //
6 //  To support this game please make sure you check out the sponsor in the public sponsor variable of each game
7 //
8 //  how to play:
9 //
10 //  1) 20 racers can register, race starting fee is 50 ether per entry (only one entry per person allowed!)
11 //  2) Once 20 racers have registered, anyone can start the race by hitting the start_the_race() function
12 //  3) Once the race has started, every racer has to hit the drive() function as often as they can
13 //  4) After approx 30 mins (~126 blocks) the race ends, and the winner can claim his price
14 //         (price is all entry fees, as well as whatever was in the additional_price_money pool to start with )
15 //      
16 //  Please note that we'll try to find a different sponsor for each race (who contributes to the additional_price_money pool)
17 //  Dont forget to check out the sponsor of this game!
18 //
19 //  Please send any comments or questions about this game to philipp.burkard@yahoo.com, I will try to respond within a day.
20 //  Languages spoken: English, German, a little Spanish
21 //
22 
23 contract TheGreatEtherRace {
24 
25    mapping(uint256 => address) public racers; //keeps racers (index 1..total_racers)
26    mapping(address => uint256) public racer_index; // address to index
27    
28    mapping(address => uint256) public distance_driven; // keeps track of the race/progress of players
29    
30    string public sponsor;
31    
32    uint256 public total_racers;      // number of racers, once reached the race can start
33    uint256 public registered_racers; // how many racers do we have already
34    uint256 public registration_fee;  // how much is it to participate
35    uint256 public additional_price_money;
36    uint256 public race_start_block;  // block number that indicates when the race starts (set after everyone has signed up)
37    
38    address public winner;
39    
40    address developer_address; // to give developer his 5 ether fee
41    address creator;
42 
43    enum EvtStatus { SignUp, ReadyToStart, Started, Finished }
44    EvtStatus public eventStatus;
45    
46    function getStatus() constant returns (string) {
47        if (eventStatus == EvtStatus.SignUp) return "SignUp";
48        if (eventStatus == EvtStatus.ReadyToStart) return "ReadyToStart";
49        if (eventStatus == EvtStatus.Started) return "Started";
50        if (eventStatus == EvtStatus.Finished) return "Finished";
51    }
52    
53    function additional_incentive() public payable { // additional ether to win, on top of other racers contribution
54        additional_price_money += msg.value;
55    }
56    
57    function TheGreatEtherRace(string p_sponsor){ // create the contract
58        sponsor = p_sponsor;
59        total_racers = 20;
60        registered_racers = 0;
61        registration_fee = 50 ether;
62        eventStatus = EvtStatus.SignUp;
63        developer_address = 0x6d5719Ff464c6624C30225931393F842E3A4A41a;
64        creator = msg.sender;
65    }
66    
67    /// 1) SIGN UP FOR THE RACE (only one entry per person allowed)
68    
69    function() payable { // buy starting position by simply transferring 
70         uint store;
71         if ( msg.value < registration_fee ) throw;    // not enough paid to 
72         if ( racer_index[msg.sender] > 0  ) throw;    // already part of the race
73         if ( eventStatus != EvtStatus.SignUp ) throw; // are we still in signup phase
74         
75         registered_racers++;
76         racer_index[msg.sender] = registered_racers;  // store racer index/position
77         racers[registered_racers] = msg.sender;       // store racer by index/position
78         if ( registered_racers >= total_racers){      // race is full, lets begin..
79             eventStatus = EvtStatus.ReadyToStart;     // no more buy in's possible
80             race_start_block = block.number + 42;  // race can start ~ 10 minutes after last person has signed up
81         }
82    }
83    
84    /// 2) START THE RACE
85    
86    function start_the_race() public {
87        if ( eventStatus != EvtStatus.ReadyToStart ) throw; // race is not ready to be started yet
88        if (block.number < race_start_block) throw;            // race starting block not yet reached
89        eventStatus = EvtStatus.Started;
90    }
91    
92    /// 3) DRIVE AS FAST AS YOU CAN (hit this function as often as you can within the next 30 mins )
93    function drive() public {
94        if ( eventStatus != EvtStatus.Started ) throw;
95        
96        if ( block.number > race_start_block + 126 ){ 
97            
98            eventStatus = EvtStatus.Finished;
99            
100            // find winner
101            winner = racers[1];
102            for (uint256 idx = 2; idx <= registered_racers; idx++){
103                if ( distance_driven[racers[idx]] > distance_driven[winner]  ) // note: in case of equal distance, the racer who signed up earlier wins
104                     winner = racers[idx];
105            }
106            return;
107        }
108        distance_driven[msg.sender]++; // drive 1 unit
109    }
110    
111    // 4) CLAIM WINNING MONEY
112    
113    function claim_price_money() public {
114        
115        if  (eventStatus == EvtStatus.Finished){
116                 uint winning_amount = this.balance - 5 ether;  // balance minus 5 ether fee
117                 if (!winner.send(winning_amount)) throw;       // send to winner
118                 if (!developer_address.send(5 ether)) throw;   // send 5 ether to developer
119        }
120        
121    }
122 
123    
124    // cleanup no earlier than 3 days after race (to allow for enough time to claim), or while noone has yet registered
125    function cleanup() public {
126        if (msg.sender != creator) throw;
127        if (
128              registered_racers == 0 ||    // noone has yet registered
129              eventStatus == EvtStatus.Finished && block.number > race_start_block + 18514 // finished, and 3 days have passed
130           ){
131            selfdestruct(creator);
132        } 
133        else throw;
134    }
135     
136 }