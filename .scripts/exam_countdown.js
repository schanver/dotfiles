const exams = [
{
  name: "BDA 1.Termin",
  date: "2026-02-27"
},
{
  name: "ES 1.Termin",
  date: "2026-03-02"
},
{
  name: "SQ 1.Termin",
  date: "2026-02-17"
},
{
  name: "BDA 2.Termin",
  date: "2026-03-31"
},
{
    name: "ES 2.Termin",
    date: "2026-04-09"
},
{
    name: "SQ 2.Termin",
    date: "2026-04-01"
}
]

const today = new Date();
today.setHours(0, 0, 0, 0);

exams.forEach(exam => {
  const examDate = new Date(exam.date);
  const diffMs = examDate - today;
  const diffDays = Math.ceil(diffMs / (1000 * 60 * 60 * 24));

  if (diffDays > 0) {
    console.log(`${exam.name}: ${diffDays} Tagen noch`);
  } else if (diffDays === 0) {
    console.log(`${exam.name}: Heute`);
  } else {
    console.log(`${exam.name}: is verpasst`);
  }
});
