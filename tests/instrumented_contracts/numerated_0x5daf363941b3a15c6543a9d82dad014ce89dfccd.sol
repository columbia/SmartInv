1 contract MPO { 
2 	uint256 public reading;
3 	uint256 public time;
4 	address public operator; 
5 	uint256 shift;
6 	string public name ="MP";
7 	string public symbol ="Wh";
8 	event Transfer(address indexed from, address indexed to, uint256 value);
9 	mapping (address => uint256) public balanceOf;
10 	address[] public listeners;
11 	
12 	function MPO() {
13 		operator=msg.sender;
14 		shift=0;
15 	}
16 	
17 	function updateReading(uint256 last_reading,uint256 timeofreading) {		
18 		if(msg.sender!=operator) throw;
19 		if((timeofreading<time)||(reading>last_reading)) throw;	
20 		var oldreading=last_reading;
21 		reading=last_reading-shift;
22 		time=timeofreading;	
23 		balanceOf[this]=last_reading;
24 		for(var i=0;i<listeners.length;i++) {
25 			balanceOf[listeners[i]]=last_reading;
26 			Transfer(msg.sender,listeners[i],last_reading-oldreading);
27 		}
28 	}
29 	
30 	function reqisterListening(address a) {
31 		listeners.push(a);
32 		balanceOf[a]=reading;
33 		Transfer(msg.sender,a,reading);
34 	}
35 	function transferOwnership(address to) {
36 		if(msg.sender!=operator) throw;
37 		operator=to;
38 	}
39 	function transfer(address _to, uint256 _value) {
40 		/* Function stub required to see tokens in wallet */		
41         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
42     }
43 	function assetMoveInformation(address newmpo,address gridMemberToInform) {
44 		if(msg.sender!=operator) throw;
45 		/*var gm=GridMember(gridMemberToInform);
46 		gm.switchMPO(this,newmpo);
47 		*/
48 	}
49 	
50 }
51 contract MPOListener {
52 	MPO public mp;
53 	
54 	function switchMPO(address from, address to) {
55 		if(msg.sender!=mp.operator()) throw;
56 		if(mp==from) {
57 			mp=MPO(to);			
58 		}
59 	}
60 }