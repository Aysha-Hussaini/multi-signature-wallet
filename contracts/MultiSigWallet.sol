pragma solidity ^0.4.10;

contract MultiSigWallet{
   struct Transaction {
      address recipient;
      uint value;
      bytes data;
      bool executed;
      uint confirmations;
   }

   Transaction[] public transactions; //array of struct Transaction

   address[] public owners;
   uint public requiredConfirmations;
   mapping(address => bool) public uniqueOwners;


   /// @dev Constructor
   constructor (address[] memory _owners, uint _requiredConfirmations) public {
      require(_owners.length >0, "Owners are required");
      require(r_equiredConfirmations >0 && _requiredConfirmations <=owners.length, "Invalid confirmations");

      for (uint i=0;i < _owners.length; i++){
         address owner = _owners[i];

         owners.push(owner);
         uniqueOwners[owner] = true;
      }
      requiredConfirmations = _requiredConfirmations;
   }

   function submitTransaction(address _recipient, uint _value, bytes _data) public returns(uint){
      transactions.push(
         Transaction({
            recipient: _recipient,
            value: _value,
            data: _data,
            executed: false,
            confirmations: 0
         });
         uint txID = transactions.length;
         return txID
      )
   }

   function confirmTransaction(uint _txID) public{
      if(isConfirmed(_txID)) {
      transactions[_txID].confirmations += 1;
      }
   }

   function executeTransaction(uint _txID) public {
      require(transactions[_txID].confirmations >= requiredConfirmations, "Not enough confirmations")
      transactions[_txID].executed = true;
   }

   function isConfirmed(uint _txID, address _caller) internal constant returns(bool) {
      require(!transactions[_txID].executed,"transaction already executed");
      return true;
   }
}