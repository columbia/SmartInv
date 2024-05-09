1 pragma solidity ^0.4.18;
2 
3 contract Upload{
4     
5     struct dataStruct{
6         string nama;
7         string alamat;
8         string file;
9     }
10     
11     mapping (uint => dataStruct) data;
12 
13     
14     function addData(uint8 idData, string namaData, string alamatData, string fileData) public{
15         data[idData].nama = namaData;
16         data[idData].alamat = alamatData;
17         data[idData].file = fileData;
18     }
19     
20     function getDataById(uint8 idData) constant public returns (string, string, string){
21         return (data[idData].nama, data[idData].alamat, data[idData].file);
22     }
23 }