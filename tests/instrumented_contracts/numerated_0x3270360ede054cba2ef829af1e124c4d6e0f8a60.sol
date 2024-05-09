1 pragma solidity ^0.4.23;
2 
3 // @author: Ghilia Weldesselasie
4 // An experiment in using contracts as public DBs on the blockchain
5 
6 contract Database {
7 
8     address public owner;
9 
10     constructor() public {
11       owner = msg.sender;
12     }
13     
14     function withdraw() public {
15       require(msg.sender == owner);
16       owner.transfer(address(this).balance);
17     }
18 
19     // Here the 'Table' event is treated as an SQL table
20     // Each property is indexed and can be retrieved easily via web3.js
21     event Table(uint256 indexed _row, bytes32 indexed _column, bytes32 indexed _value);
22     /*
23     _______
24     |||Table|||
25     -----------
26     | row |    _column    |    _column2   |
27     |  1  |    _value     |    _value     |
28     |  2  |    _value     |    _value     |
29     |  3  |    _value     |    _value     |
30     */
31 
32     function put(uint256 _row, string _column, string _value) public {
33         emit Table(_row, keccak256(_column), keccak256(_value));
34     }
35 }