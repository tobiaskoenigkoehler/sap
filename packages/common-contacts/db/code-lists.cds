using { sap.capire.contacts.PostalAddress } from './schema';
using { sap } from '@sap/cds/common';
namespace sap.capire.contacts;

/**
 * The Code Lists below are designed as optional extensions to
 * the base schema. Switch them on by adding an Association to
 * one of the code list entities in your models or by:
 * annotate sap.common.Countries with @cds.persistence.skip:false;
 */

entity Countries as select from sap.common.Countries;
extend sap.common.Countries {
  regions   : Composition of many Regions on regions._parent = $self.code;
}
entity Regions : sap.common.CodeList {
  key code : String(5); // ISO 3166-2 alpha5 codes, e.g. DE-BW
  children  : Composition of many Regions on children._parent = $self.code;
  cities    : Composition of many Cities on cities.region = $self;
  _parent   : String(11);
}
entity Cities : sap.common.CodeList {
  key code  : String(11);
  region    : Association to Regions;
  districts : Composition of many Districts on districts.city = $self;
}
entity Districts : sap.common.CodeList {
  key code  : String(11);
  city      : Association to Cities;
}

annotate PostalAddress with {
  district @ref: sap.capire.contacts.Districts;
  city @ref: sap.capire.contacts.Cities;
  region @ref: sap.capire.contacts.Regions;
  country @ref: sap.capire.contacts.Countries;
}
