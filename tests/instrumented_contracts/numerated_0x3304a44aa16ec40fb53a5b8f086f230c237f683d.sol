1 /**
2  * Copyright (C) 2017-2018 Hashfuture Inc. All rights reserved.
3  */
4 
5 
6 pragma solidity ^0.4.19;
7 
8 contract owned {
9     address public owner;
10 
11     constructor() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) onlyOwner public {
21         owner = newOwner;
22     }
23 }
24 
25 contract mall is owned {
26 
27     /* Struct for one commodity */
28     struct Commodity {
29         uint commodityId;            // Unique id for a commodity
30         uint seedBlock;         // Block number whose hash as random seed
31         string MD5;         // MD5 of full content
32     }
33 
34     uint commodityNum;
35     /* This notes all commodities and a map from commodityId to commodityIdx */
36     mapping(uint => Commodity) commodities;
37     mapping(uint => uint) indexMap;
38 
39     /** constructor */
40     constructor() public {
41         commodityNum = 1;
42     }
43 
44     /**
45      * Initialize a new Commodity
46      */
47     function newCommodity(uint commodityId, uint seedBlock, string MD5) onlyOwner public returns (uint commodityIndex) {
48         require(indexMap[commodityId] == 0);             // commodityId should be unique
49         commodityIndex = commodityNum++;
50         indexMap[commodityId] = commodityIndex;
51         commodities[commodityIndex] = Commodity(commodityId, seedBlock, MD5);
52     }
53 
54     /**
55      * Get commodity info by index
56      * Only can be called by newOwner
57      */
58     function getCommodityInfoByIndex(uint commodityIndex) onlyOwner public view returns (uint commodityId, uint seedBlock, string MD5) {
59         require(commodityIndex < commodityNum);               // should exist
60         require(commodityIndex >= 1);                    // should exist
61         commodityId = commodities[commodityIndex].commodityId;
62         seedBlock = commodities[commodityIndex].seedBlock;
63         MD5 = commodities[commodityIndex].MD5;
64     }
65 
66     /**
67      * Get commodity info by commodity id
68      * Only can be called by newOwner
69      */
70     function getCommodityInfoById(uint commodityId) public view returns (uint commodityIndex, uint seedBlock, string MD5) {
71         commodityIndex = indexMap[commodityId];
72         require(commodityIndex < commodityNum);              // should exist
73         require(commodityIndex >= 1);                   // should exist
74         seedBlock = commodities[commodityIndex].seedBlock;
75         MD5 = commodities[commodityIndex].MD5;
76     }
77 
78     /**
79      * Get the number of commodities
80      */
81     function getCommodityNum() onlyOwner public view returns (uint num) {
82         num = commodityNum - 1;
83     }
84 }