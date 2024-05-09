1 pragma solidity 0.5.2;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract IPolaris {
6     struct Checkpoint {
7         uint ethReserve;
8         uint tokenReserve;
9     }
10 
11     struct Medianizer {
12         uint8 tail;
13         uint pendingStartTimestamp;
14         uint latestTimestamp;
15         Checkpoint[] prices;
16         Checkpoint[] pending;
17         Checkpoint median;
18     }
19     function subscribe(address token) public payable;
20     function unsubscribe(address token, uint amount) public returns (uint actualAmount);
21     function getMedianizer(address token) public view returns (Medianizer memory);
22     function getDestAmount(address src, address dest, uint srcAmount) public view returns (uint);
23 }
24 
25 
26 contract MarbleSubscriber {
27 
28     IPolaris public oracle;
29 
30     constructor(address _oracle) public {
31         oracle = IPolaris(_oracle);
32     }
33 
34     function subscribe(address asset) public payable returns (uint) {
35         oracle.subscribe.value(msg.value)(asset);
36     }
37 
38     function getDestAmount(address src, address dest, uint srcAmount) public view returns (uint) {
39         return oracle.getDestAmount(src, dest, srcAmount);
40     }
41 
42     function getMedianizer(address token) public view returns (IPolaris.Medianizer memory) {
43         return oracle.getMedianizer(token);
44     }
45 }