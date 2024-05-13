1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ Internal Imports ============
5 import {IUpdaterManager} from "../interfaces/IUpdaterManager.sol";
6 import {Home} from "./Home.sol";
7 // ============ External Imports ============
8 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
9 import {Address} from "@openzeppelin/contracts/utils/Address.sol";
10 
11 /**
12  * @title UpdaterManager
13  * @author Illusory Systems Inc.
14  * @notice MVP / centralized version of contract
15  * that will manage Updater bonding, slashing,
16  * selection and rotation
17  */
18 contract UpdaterManager is IUpdaterManager, Ownable {
19     // ============ Internal Storage ============
20 
21     // address of home contract
22     address internal home;
23 
24     // ============ Private Storage ============
25 
26     // address of the current updater
27     address private _updater;
28 
29     // ============ Events ============
30 
31     /**
32      * @notice Emitted when a new home is set
33      * @param home The address of the new home contract
34      */
35     event NewHome(address home);
36 
37     /**
38      * @notice Emitted when slashUpdater is called
39      */
40     event FakeSlashed(address reporter);
41 
42     // ============ Modifiers ============
43 
44     /**
45      * @notice Require that the function is called
46      * by the Home contract
47      */
48     modifier onlyHome() {
49         require(msg.sender == home, "!home");
50         _;
51     }
52 
53     // ============ Constructor ============
54 
55     constructor(address _updaterAddress) payable Ownable() {
56         _updater = _updaterAddress;
57     }
58 
59     // ============ External Functions ============
60 
61     /**
62      * @notice Set the address of the a new home contract
63      * @dev only callable by trusted owner
64      * @param _home The address of the new home contract
65      */
66     function setHome(address _home) external onlyOwner {
67         require(Address.isContract(_home), "!contract home");
68         home = _home;
69 
70         emit NewHome(_home);
71     }
72 
73     /**
74      * @notice Set the address of a new updater
75      * @dev only callable by trusted owner
76      * @param _updaterAddress The address of the new updater
77      */
78     function setUpdater(address _updaterAddress) external onlyOwner {
79         _updater = _updaterAddress;
80         Home(home).setUpdater(_updaterAddress);
81     }
82 
83     /**
84      * @notice Slashes the updater
85      * @dev Currently does nothing, functionality will be implemented later
86      * when updater bonding and rotation are also implemented
87      * @param _reporter The address of the entity that reported the updater fraud
88      */
89     function slashUpdater(address payable _reporter)
90         external
91         override
92         onlyHome
93     {
94         emit FakeSlashed(_reporter);
95     }
96 
97     /**
98      * @notice Get address of current updater
99      * @return the updater address
100      */
101     function updater() external view override returns (address) {
102         return _updater;
103     }
104 }
