1 contract LifeSet_002 {
2   uint256 public consecutiveDeaths;
3   uint256 lastHash;
4   uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
5   uint256 blockValue;
6   uint256 lifeCoin;
7   uint256 deathCoin;
8   uint256 _hedge;
9   
10 
11   function LifeSet_002() public {
12     consecutiveDeaths = 0;
13   }
14 
15   function ReinsureSeveralDeaths(bool _hedge) public returns (bool) {
16     uint256 blockValue = uint256(block.blockhash(block.number-1));
17 
18     if (lastHash == blockValue) {
19       revert();
20     }
21 
22     lastHash = blockValue;
23     uint256 lifeCoin = blockValue / FACTOR;
24     bool deathCoin = lifeCoin == 1 ? true : false;
25 
26     if (deathCoin == _hedge) {
27       consecutiveDeaths++;
28       return true;
29     } else {
30       consecutiveDeaths = 0;
31       return false;
32     }
33   }
34 
35   function	getConsecutiveDeaths	()	public	constant	returns	(	uint256	)	{
36     return	consecutiveDeaths ;						
37 	}
38 	
39   function	getLastHash	()	public	constant	returns	(	uint256	)	{
40     return	lastHash ;						
41 	}  
42   function	getFACTOR	()	public	constant	returns	(	uint256	)	{
43     return	FACTOR ;						
44 	}	
45   
46   function	getBlockNumber	()	public	constant	returns	(	uint256	)	{
47     return	(block.number) ;						
48 	}  
49  
50   function	getBlockNumberM1	()	public	constant	returns	(	uint256	)	{
51     return	(block.number-1) ;						
52 	}  
53 
54   function	getBlockHash	()	public	constant	returns	(	uint256	)	{
55     return	uint256(block.blockhash(block.number-1)) ;						
56 	}   
57 	
58   function	getBlockValue	()	public	constant	returns	(	uint256	)	{
59     return	blockValue ;						
60 	}     
61 	
62   function	getLifeCoin	()	public	constant	returns	(	uint256	)	{
63     return	lifeCoin ;						
64 	}     
65 	
66   function	getDeathCoin	()	public	constant	returns	(	uint256	)	{
67     return	deathCoin ;						
68 	}    
69 	
70   function	get_hedge	()	public	constant	returns	(	uint256	)	{
71     return	_hedge ;						
72 	}     
73 }