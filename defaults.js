window.DEF={
about_hi:"ब्राइट पब्लिक स्कूल, कोइलाबाज़ार, राजमहल (झारखंड), CBSE बोर्ड के अंतर्गत नर्सरी से कक्षा 5 तक की पढ़ाई कराता है।",
about_en:"Bright Public School, Koilabazar, Rajmahal (Jharkhand), teaches Nursery to Class 5 under the CBSE board.",
about_hn:"Bright Public School, Koilabazar, Rajmahal (Jharkhand), CBSE board ke antargat Nursery se Class 5 tak ki padhai karata hai.",
fac_hi:"",fac_en:"",fac_hn:"",
school_name:"Bright Public School",
h1_hi:"हर बच्चे की पहचान, हर बच्चे का भविष्य।",
h1_en:"Every child known. Every future bright.",
h1_hn:"Har bachche ki pehchaan, har bachche ka bhavishya.",
sub_hi:"नर्सरी से कक्षा 5 तक CBSE शिक्षा। कोइलाबाज़ार, राजमहल।",
sub_en:"CBSE education from Nursery to Class 5 at Koilabazar, Rajmahal.",
sub_hn:"Nursery se Class 5 tak CBSE shiksha. Koilabazar, Rajmahal.",
adm_p_hi:"नए सत्र के लिए प्रवेश खुले हैं। कृपया ये दस्तावेज़ लेकर स्कूल ऑफिस आएं:",
adm_p_en:"Admissions are open for the new session. Please bring these documents to the school office:",
adm_p_hn:"Naye session ke liye admission khule hain. Kripya ye documents lekar school office aayein:",
docs_hi:"बच्चे का जन्म प्रमाण पत्र\nपिछली कक्षा की रिपोर्ट कार्ड\n4 फोटो\nपते का प्रमाण",
docs_en:"Child's birth certificate\nPrevious class report card\n4 photographs\nAddress proof",
docs_hn:"Bachche ka janm praman patra\nPichhli class ka report card\n4 photo\nPate ka praman",
fees:"Nursery – UKG | ₹ 000 | ₹ 000\nClass 1 – 5 | ₹ 000 | ₹ 000",
fee_note_hi:"सही शुल्क के लिए स्कूल ऑफिस से संपर्क करें।",
fee_note_en:"Please contact the school office for exact fees.",
fee_note_hn:"Sahi fees ke liye school office se sampark karein.",
address:"Koilabazar, Rajmahal, Jharkhand",
phone:"+91 00000 00000",
email:"",
whatsapp:"",
hours_hi:"सोमवार से शनिवार, सुबह 8 से दोपहर 2 बजे",
hours_en:"Monday to Saturday, 8:00 am to 2:00 pm",
hours_hn:"Somvaar se Shanivaar, subah 8 baje se dopahar 2 baje tak"};
(function(){
 const base={
  h1:["मुख्य शीर्षक","Main heading","Main heading"],
  sub:["उप-शीर्षक","Sub text","Sub text"],
  about:["स्कूल के बारे में","About school","School ke baare mein"],
  fac:["सुविधाएँ (हर पंक्ति में एक; खाली छोड़ें तो सेक्शन छिप जाएगा)","Facilities (one per line; leave empty to hide the section)","Facilities (har line mein ek; khali chhodein to section chhup jayega)"],
  adm_p:["प्रवेश परिचय","Admission intro","Admission ka parichay"],
  docs:["ज़रूरी दस्तावेज़ (हर पंक्ति में एक)","Required documents (one per line)","Zaroori documents (har line mein ek)"],
  fee_note:["फीस नोट","Fees note","Fees ka note"],
  hours:["ऑफिस समय","Office time","Office ka samay"]};
 const area={sub:1,about:1,fac:1,adm_p:1,docs:1};
 const lg={hi:["(हिंदी)","(Hindi)","(Hindi)"],en:["(अंग्रेज़ी)","(English)","(English)"],hn:["(हिंग्लिश)","(Hinglish)","(Hinglish)"]};
 const trio=k=>['hi','en','hn'].forEach(l=>F.push([k+'_'+l,base[k].map((t,i)=>t+' '+lg[l][i]),area[k]?'area':'']));
 const F=[["school_name",["स्कूल का नाम","School name","School ka naam"]]];
 trio('h1');trio('sub');trio('about');trio('fac');trio('adm_p');trio('docs');
 F.push(["fees",["फीस तालिका (हर पंक्ति: कक्षा | प्रवेश शुल्क | मासिक शुल्क)","Fees table (each line: Class | Admission fee | Monthly fee)","Fees table (har line: Class | Admission fee | Monthly fee)"],'area']);
 trio('fee_note');
 F.push(["address",["पता","Address","Pata"]]);
 F.push(["phone",["फ़ोन नंबर","Phone number","Phone number"]]);
 F.push(["email",["ईमेल (वैकल्पिक)","Email (optional)","Email (optional)"]]);
 F.push(["whatsapp",["WhatsApp नंबर (देश कोड के साथ, जैसे 919876543210; खाली छोड़ें तो फ़ोन नंबर लगेगा)","WhatsApp number (with country code, e.g. 919876543210; leave empty to use the phone number)","WhatsApp number (country code ke saath, jaise 919876543210; khali chhodein to phone number lagega)"]]);
 trio('hours');
 window.SITE_FIELDS=F;
})();
