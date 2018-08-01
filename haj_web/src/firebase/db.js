import {db} from './firebase'
import * as Base from '../Constants/Base'

// Retrieve Mfawjeen

export const fetchMfwejeen = () =>
  db.ref(Base.Crowd);



export const fetchCampaignWtihId = (campaign_id) =>
  db.ref(Base.Campaign).child(campaign_id).once('value');
