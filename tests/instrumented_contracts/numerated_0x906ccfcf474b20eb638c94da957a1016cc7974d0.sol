1 contract BitSTDView{
2     function symbol()constant  public returns(string) {}
3     function migration(address add) public{}
4     function transfer(address _to, uint256 _value) public {}
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
6 }
7 contract airDrop{
8     /**
9      *
10      *This is a fixed airdrop
11      *
12      * @param contractaddress this is Address of airdrop token contract
13      * @param dsts this is Batch acceptance address
14      * @param value this is Issuing number
15      */
16     function airDrop_(address contractaddress,address[] dsts,uint256 value) public {
17 
18         uint count= dsts.length;
19         require(value>0);
20         BitSTDView View= BitSTDView(contractaddress);
21         for(uint i = 0; i < count; i++){
22            View.transfer(dsts[i],value);
23         }
24     }
25     /**
26      *
27      * This is a multi-value airdrop
28      *
29      * @param contractaddress this is Address of airdrop token contract
30      * @param dsts this is Batch acceptance address
31      * @param values This is the distribution number array
32      */
33     function airDropValues(address contractaddress,address[] dsts,uint256[] values) public {
34 
35         uint count= dsts.length;
36         BitSTDView View= BitSTDView(contractaddress);
37         for(uint i = 0; i < count; i++){
38            View.transfer(dsts[i],values[i]);
39         }
40     }
41     /**
42      *
43      * This is a multi-value airdrop
44      *
45      * @param contractaddress this is Address of airdrop token contract
46      * @param dsts This is the address where the data needs to be migrated
47      */
48     function dataMigration(address contractaddress,address[] dsts)public{
49         uint count= dsts.length;
50         BitSTDView View= BitSTDView(contractaddress);
51         for(uint i = 0; i < count; i++){
52            View.migration(dsts[i]);
53         }
54     }
55     /**
56      *
57      *This is Authorization drop
58      * @param _from Assigned address
59      * @param contractaddress this is Address of airdrop token contract
60      * @param dsts this is Batch acceptance address
61      * @param value this is Issuing number
62      */
63     function transferFrom(address contractaddress,address _from, address[] dsts, uint256 value) public returns (bool success) {
64         uint count= dsts.length;
65         BitSTDView View= BitSTDView(contractaddress);
66         for(uint i = 0; i < count; i++){
67            View.transferFrom(_from,dsts[i],value);
68         }
69     }
70 
71 }