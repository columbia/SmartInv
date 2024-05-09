1 pragma solidity ^0.4.21;
2 
3 contract NanoLedgerABI{
4     
5     struct data{
6         string company;
7         string valid_date;
8     }
9     
10     mapping (uint => data) datas;
11 
12     
13     function save(uint256 _id, string _company, string _valid_date) public{
14         datas[_id].company = _company;
15         datas[_id].valid_date = _valid_date;
16     }
17     
18     function readCompany(uint8 _id) view public returns (string){
19        return datas[_id].company;
20     }
21     function readValidDate(uint8 _id) view public returns (string){
22        return datas[_id].valid_date;
23     }
24 }