class carrera{
  var materias = #{}
  var estudiantes = #{}  
    method materias(){
      return materias
    }
    method agregarMateria(materia){
      materias.add(materia)
    }
    method inscribirEstudiante(estudiante){
      estudiantes.add(estudiante)
    }
    method estudiantes(){
      return estudiantes
    }
    method materiasHabilitadasParaEstudiante(estudiante){
      return materias.filter({ materia => estudiante.puedeInscribirseA(materia)})
    }
}
class materia{
  var estudiantes = #{}
  var requisitos = #{}
  var carreraDeLaMateria = carrera
    method inscribirEstudiante(estudiante){
      estudiantes.add(estudiante)
    }
    method carrera(_carrera){
      carreraDeLaMateria = _carrera
    }
    method carrera(){
      return carreraDeLaMateria
    }
    method requisitos(_requisito) {
      requisitos.add(_requisito)
    }
    method requisitos(){
      return requisitos
    }
}
object correlativas{

}
object creditos{
  
}
object sinRequisitos{
  
}

class estudiante{
  var nombre = ""
  var materiasQueCurso = #{}  
  var carrerasQueCurso = #{}
  var historial = ""  
    method nombre(){
      return nombre
    }
    method inscribirmeAMateria(materia){
      self.validarQueNoEsteIncriptoALaMateria(materia)
      self.validarQueLaMateriaNoEsteAprobada(materia)
      self.validarSiLaMateriaEsDeMisCarreras(materia)
      self.validarQueTengaAprobadoSusRequisitos(materia)
      materia.inscribirEstudiante(self)
      materiasQueCurso.add(materia) 
    }
    method validarQueNoEsteIncriptoALaMateria(materia){
      if ( self.estaInscriptoAMateria(materia) )
        {self.error("ya esta inscripto a la materia")}
    }
    method validarQueLaMateriaNoEsteAprobada(materia){
      if (self.tieneAprobada(materia)) 
        {self.error("la materia ya esta aprobada")}
    }
    method validarSiLaMateriaEsDeMisCarreras(materia){
      if(not self.materiaEsDeMisCarreras(materia))
        {self.error("la materia no corresponde a mis carreras")}
    }
    method validarQueTengaAprobadoSusRequisitos(materia){
      if(not self.tengoAprobadoSusRequisitos(materia)) 
        {self.error("no tiene aprobo los requisitos")}
    }
    method inscribirmeACarrera(_carrera){
      _carrera.inscribirEstudiante(self)
      carrerasQueCurso.add(_carrera)
    }
    method carrerasInscriptas() {
      return carrerasQueCurso
    }
    method materiasInscriptas(){
      return materiasQueCurso
    }
    method materiasDeMisCarreras(){
      return carrerasQueCurso.map({_carrera => _carrera.materias()})
    }
    method materiaEsDeMisCarreras(materia) {
      return carrerasQueCurso.any({carrera => carrera.materias().contains(materia)})
    }
    method agregarHistorial(_historialAcademico){
      historial = _historialAcademico
    }
    method historial(){
      return historial
    }
    method registrarCursada(_cursada){
      self.validarNotaDeLaCursada(_cursada)
      self.validarSiYaEstaAprobada(_cursada)
      self.cursadaEsDeMisCarreras(_cursada)
      historial.registrarCursada(_cursada)
    }
    method validarNotaDeLaCursada(_cursada){
      if (_cursada.nota() < 1 || _cursada.nota() > 10 ) 
        {self.error("la nota debe estar entre 1 y 10")}
    }
    method validarSiYaEstaAprobada(_cursada){
      if (historial.tieneAprobada(_cursada.materia()))
        {self.error("ya aprobe esa materia")}
    }
    method cursadaEsDeMisCarreras(_cursada){
      if (not (self.materiaEsDeMisCarreras(_cursada.materia()))) 
        {self.error("esta materia no es parte de mis carreras")}
    }
    method cantidadAprobadasEn(_carrera) {
      return historial.cantidadAprobadasEn(_carrera)
    }
    method promedioAprobadasEn(_carrera) {
      return historial.promedioAprobadasEn(_carrera)
    }
    method cantidadAprobadas() {
      return historial.cantidadAprobadas()
    }
    method promedioAprobadas() {
      return historial.promedioAprobadas()
    }
    method cursadasDe(materia) {
      return historial.cursadasDe(materia)
    }
    method tieneAprobada(materia){
      return historial.tieneAprobada(materia)
    }
    method estaInscriptoAMateria(materia){
      return materiasQueCurso.contains(materia)
    }
    method tengoAprobadoSusRequisitos(materia){
      return materia.requisitos().all({ requisito => self.tieneAprobada(requisito)})
    }
    method puedeInscribirseA(materia) {
  return (self.materiaEsDeMisCarreras(materia) && 
      not self.tieneAprobada(materia) && 
      not self.estaInscriptoAMateria(materia) && 
          self.tengoAprobadoSusRequisitos(materia))
    }
    method materiasHabilitadasEnCarrera(_carrera){
      return _carrera.materiasHabilitadasParaEstudiante(self)
    }
}
class historialAcademico {
  const cursadas = []

  method registrarCursada(cursada) {
    cursadas.add(cursada)
  }
  method todasLasCursadas() {
    return cursadas
  }
  method cursadasDe(materia) {
    return cursadas.filter({ cursada =>cursada.materia() == materia})
  }
  method tieneAprobada(materia) {
    return self.cursadasDe(materia).any({ cursada =>cursada.estaAprobada()})
  }
  method cursadasAprobadasEn(carrera) {
    return cursadas.filter({ unaCursada => carrera.materias().contains(unaCursada.materia()) && unaCursada.estaAprobada()})
  }
  method cantidadAprobadasEn(carrera) {
    return self.cursadasAprobadasEn(carrera).size()
  }
  method sumaNotasAprobadasEn(carrera) {
    return self.cursadasAprobadasEn(carrera).sum({ unaCursada => unaCursada.nota()})
  }
  method promedioAprobadasEn(carrera) {
    return self.sumaNotasAprobadasEn(carrera) /self.cantidadAprobadasEn(carrera)
  }
  method cursadasAprobadas() {
    return cursadas.filter({ unaCursada => unaCursada.estaAprobada()})
  }
  method cantidadAprobadas() {
    return self.cursadasAprobadas().size()
  }
  method promedioAprobadas() {
    return self.cursadasAprobadas().sum({ unaCursada => unaCursada.nota()}) / self.cantidadAprobadas()
  }
}

class cursada{
  var nota = 0
  var materia = ""
    method nota(_nota){
      nota = _nota
    }
    method nota(){
      return nota
    }
    method materia(_materia){
      materia = _materia
    }
    method materia(){
      return materia
    }
    method estaAprobada(){
      return nota >= 6
    }
}