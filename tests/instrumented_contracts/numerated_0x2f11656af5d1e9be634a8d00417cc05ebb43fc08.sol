1 // File: contracts/lib/interface/IRouterRegistry.sol
2 
3 pragma solidity ^0.5.5;
4 
5 
6 /**
7  * @title RouterRegistry interface for routing
8  */
9 interface IRouterRegistry {
10     enum RouterOperation { Add, Remove, Refresh }
11 
12     function registerRouter() external;
13 
14     function deregisterRouter() external;
15 
16     function refreshRouter() external;
17 
18     event RouterUpdated(RouterOperation indexed op, address indexed routerAddress);
19 }
20 
21 // File: contracts/RouterRegistry.sol
22 
23 pragma solidity ^0.5.5;
24 
25 
26 /**
27  * @title Router Registry contract for external routers to join the Celer Network
28  * @notice Implementation of a global registry to enable external routers to join
29  */
30 contract RouterRegistry is IRouterRegistry {
31     // mapping to store the registered routers address as key 
32     // and the lastest registered/refreshed block number as value
33     mapping(address => uint) public routerInfo;
34 
35     /**
36      * @notice An external router could register to join the Celer Network
37      */
38     function registerRouter() external {
39         require(routerInfo[msg.sender] == 0, "Router address already exists");
40 
41         routerInfo[msg.sender] = block.number;
42 
43         emit RouterUpdated(RouterOperation.Add, msg.sender);
44     }
45 
46     /**
47      * @notice An in-network router could deregister to leave the network
48      */
49     function deregisterRouter() external {
50         require(routerInfo[msg.sender] != 0, "Router address does not exist");
51 
52         delete routerInfo[msg.sender];
53 
54         emit RouterUpdated(RouterOperation.Remove, msg.sender);
55     }
56 
57     /**
58      * @notice Refresh the existed router's block number
59      */
60     function refreshRouter() external {
61         require(routerInfo[msg.sender] != 0, "Router address does not exist");
62 
63         routerInfo[msg.sender] = block.number;
64 
65         emit RouterUpdated(RouterOperation.Refresh, msg.sender);
66     }
67 }