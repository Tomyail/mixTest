/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package data
{
    /**
	 * Wraps a data source with a common API for use with UI controls, like
	 * lists, that support one dimensional collections of data. Supports custom
	 * "data descriptors" so that unexpected data sources may be used. Supports
	 * Arrays, Vectors, and XMLLists automatically.
	 * 
	 * @see data.ArrayListCollectionDataDescriptor
	 * @see data.VectorListCollectionDataDescriptor
	 * @see data.XMLListListCollectionDataDescriptor
	 */
	public class ListCollection
	{
		/**
		 * Constructor
		 */
		public function ListCollection(data:Object = null)
		{
			if(!data)
			{
				//default to an array if no data is provided
				data = [];
			}
			this.data = data;
		}
		
		/**
		 * @private
		 */
		protected var _data:Object;
		
		/**
		 * The data source for this collection. May be any type of data, but a
		 * <code>dataDescriptor</code> needs to be provided to translate from
		 * the data source's APIs to something that can be understood by
		 * <code>ListCollection</code>.
		 * 
		 * <p>Data sources of type Array, Vector, and XMLList are automatically
		 * detected, and no <code>dataDescriptor</code> needs to be set if the
		 * <code>ListCollection</code> uses one of these types.</p>
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			if(!value)
			{
				this.removeAll();
				return;
			}
			this._data = value;
			//we'll automatically detect an array, vector, or xmllist for convenience
			if(this._data is Array && !(this._dataDescriptor is ArrayListCollectionDataDescriptor))
			{
				this.dataDescriptor = new ArrayListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<Number> && !(this._dataDescriptor is VectorNumberListCollectionDataDescriptor))
			{
				this.dataDescriptor = new VectorNumberListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<int> && !(this._dataDescriptor is VectorIntListCollectionDataDescriptor))
			{
				this.dataDescriptor = new VectorIntListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<uint> && !(this._dataDescriptor is VectorUintListCollectionDataDescriptor))
			{
				this.dataDescriptor = new VectorUintListCollectionDataDescriptor();
			}
			else if(this._data is Vector.<*> && !(this._dataDescriptor is VectorListCollectionDataDescriptor))
			{
				this.dataDescriptor = new VectorListCollectionDataDescriptor();
			}
			else if(this._data is XMLList && !(this._dataDescriptor is XMLListListCollectionDataDescriptor))
			{
				this.dataDescriptor = new XMLListListCollectionDataDescriptor();
			}
		}
		
		/**
		 * @private
		 */
		protected var _dataDescriptor:IListCollectionDataDescriptor;

		/**
		 * Describes the underlying data source by translating APIs.
		 * 
		 * @see data.IListCollectionDataDescriptor
		 */
		public function get dataDescriptor():IListCollectionDataDescriptor
		{
			return this._dataDescriptor;
		}
		
		/**
		 * @private
		 */
		public function set dataDescriptor(value:IListCollectionDataDescriptor):void
		{
			if(this._dataDescriptor == value)
			{
				return;
			}
			this._dataDescriptor = value;
		}

		/**
		 * The number of items in the collection.
		 */
		public function get length():int
		{
			return this._dataDescriptor.getLength(this._data);
		}

		/**
		 * Returns the item at the specified index in the collection.
		 */
		public function getItemAt(index:int):Object
		{
			return this._dataDescriptor.getItemAt(this._data, index);
		}
		
		/**
		 * Determines which index the item appears at within the collection. If
		 * the item isn't in the collection, returns <code>-1</code>.
		 */
		public function getItemIndex(item:Object):int
		{
			return this._dataDescriptor.getItemIndex(this._data, item);
		}
		
		/**
		 * Adds an item to the collection, at the specified index.
		 */
		public function addItemAt(item:Object, index:int):void
		{
			this._dataDescriptor.addItemAt(this._data, item, index);
		}
		
		/**
		 * Removes the item at the specified index from the collection and
		 * returns it.
		 */
		public function removeItemAt(index:int):Object
		{
			const item:Object = this._dataDescriptor.removeItemAt(this._data, index);
			return item;
		}
		
		/**
		 * Removes a specific item from the collection.
		 */
		public function removeItem(item:Object):void
		{
			const index:int = this.getItemIndex(item);
			if(index >= 0)
			{
				this.removeItemAt(index);
			}
		}

		/**
		 * Removes all items from the collection.
		 */
		public function removeAll():void
		{
			this._dataDescriptor.removeAll(this._data);
		}
		
		/**
		 * Replaces the item at the specified index with a new item.
		 */
		public function setItemAt(item:Object, index:int):void
		{
			this._dataDescriptor.setItemAt(this._data, item, index);
		}

		/**
		 * Adds an item to the end of the collection.
		 */
		public function addItem(item:Object):void
		{
			this.addItemAt(item, this.length);
		}

		/**
		 * Adds an item to the end of the collection.
		 */
		public function push(item:Object):void
		{
			this.addItemAt(item, this.length);
		}

		/**
		 * Adds all items from another collection.
		 */
		public function addAll(collection:ListCollection):void
		{
			const otherCollectionLength:int = collection.length;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				this.addItem(item);
			}
		}

		/**
		 * Adds all items from another collection, placing the items at a
		 * specific index in this collection.
		 */
		public function addAllAt(collection:ListCollection, index:int):void
		{
			const otherCollectionLength:int = collection.length;
			var currentIndex:int = index;
			for(var i:int = 0; i < otherCollectionLength; i++)
			{
				var item:Object = collection.getItemAt(i);
				this.addItemAt(item, currentIndex);
				currentIndex++;
			}
		}
		
		/**
		 * Removes the item from the end of the collection and returns it.
		 */
		public function pop():Object
		{
			return this.removeItemAt(this.length - 1);
		}
		
		/**
		 * Adds an item to the beginning of the collection.
		 */
		public function unshift(item:Object):void
		{
			this.addItemAt(item, 0);
		}
		
		/**
		 * Removed the item from the beginning of the collection and returns it. 
		 */
		public function shift():Object
		{
			return this.removeItemAt(0);
		}

		/**
		 * Determines if the specified item is in the collection.
		 */
		public function contains(item:Object):Boolean
		{
			return this.getItemIndex(item) >= 0;
		}
	}
}