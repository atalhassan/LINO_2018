import {db} from './firebase'
import * as Base from '../Constants/Base'

// Retrieve Mfawjeen

export const fetchMfwejeen = () =>
  db.ref(Base.Crowd);
